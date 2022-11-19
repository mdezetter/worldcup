#! /bin/bash
# Script to insert data from games.csv into worldcup database

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

echo $($PSQL "TRUNCATE teams, games")

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $year != "year" ]] # beginning of != loop.

  then
    # get team_id
    winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")

    # if team_id for winner not found
    if [[ -z $winner_id ]] # Beginning of adding winner loop
    then
      # insert name of winner
      insert_winner_result=$($PSQL "INSERT INTO teams(name) VALUES('$winner')")
      if [[ $insert_winner_result == "INSERT 0 1" ]]
      then
       echo Inserted into teams, $winner
      fi

      # get new winner_id
      winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")

    fi # end of the adding winner loop

    # adding opponents
    opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")

    # if opponent_id not found
    if [[ -z $opponent_id ]] # beginning of adding opponent loop
    then
      # insert name of opponent
      insert_opponent_result=$($PSQL "INSERT INTO teams(name) VALUES('$opponent')")
      if [[ $insert_opponent_result == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $opponent
      fi

      # get new opponent_id
      opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
    
    fi # end of adding opponent loop

    # insert round
      insert_games_result=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals)")
      if [[ $insert_games_result == "INSERT 0 1" ]]
      then
        echo Inserted into games, $year, $round, $winner_id, $opponent_id, $winner_goals, $opponent_goals
      fi

  fi # end of the != loop




# insert into teams
done