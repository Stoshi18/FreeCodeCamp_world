#! /bin/bash


if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WIN OPP WING OPPG
do
  if [[ $YEAR != 'year' ]]
  then
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WIN'")

    if [[ -z $WIN_ID ]]
    then
      echo "$($PSQL "INSERT INTO teams(name) VALUES('$WIN')")"
      WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WIN'")
    fi

    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'")

    if [[ -z $OPP_ID ]]
    then
      echo "$($PSQL "INSERT INTO teams(name) VALUES('$OPP')")"
      OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'")
    fi

    echo "$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WIN_ID, $OPP_ID, $WING, $OPPG)")"

  fi

done
