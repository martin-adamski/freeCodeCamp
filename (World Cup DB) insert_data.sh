#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $winner != "winner" ]]
  then
      # Checking if team name already exists in table, and if so, getting team_id
      TEAM_ID_winner=$($PSQL "SELECT team_id FROM teams WHERE name = '$winner'")
      # if not found
      if [[ -z $TEAM_ID_winner ]]
      # insert the winner team 
      then
        INSERT_winner_TEAM_NAME_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$winner')")
        # Checking if inserted
        if [[ $INSERT_winner_TEAM_NAME_RESULT == "INSERT 0 1" ]]
        then
          echo Inserted into teams, $winner
        fi
      # Get winner team id
      TEAM_ID_winner=$($PSQL "SELECT team_id FROM teams WHERE name = '$winner'")
      fi
      # Get opponent_id
      TEAM_ID_opponent=$($PSQL "SELECT team_id FROM teams WHERE name = '$opponent'")
      # if not found
      if [[ -z $TEAM_ID_opponent ]]
      # insert the opponent team
      then
        INSERT_opponent_TEAM_NAME_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$opponent')")
        # Checking if inserted
        if [[ $INSERT_opponent_TEAM_NAME_RESULT == "INSERT 0 1" ]]
        then
          echo Inserted into teams, $opponent
        fi
      # Get oppnent team id
      TEAM_ID_opponent=$($PSQL "SELECT team_id FROM teams WHERE name = '$opponent'")
      fi
  fi
done

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $year != "year" ]]
  then
    # Setting team_id variables
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$winner'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$opponent'")

    # if not found
    if [[ -z $WINNER_ID ]]
    then 
      # set to null
      WINNER_ID=null
    fi

    # if not found
    if [[ -z $OPPONENT_ID ]]
    then 
      # set to null
      OPPONENT_ID=null
    fi

    # insert games_result
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year, '$round', $WINNER_ID, $OPPONENT_ID, $winner_goals, $opponent_goals)")
    if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted into games, $year $round $winner $winner_goals ':' $opponent_goals $opponent
    fi
  fi
done
