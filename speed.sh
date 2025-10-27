#!/bin/sh

if [ -z $1 ]; then
  echo "Usage: $0 <terminal>"
  exit 1
fi

terminal=$1
ftime=$(mktemp time.XXXXX)

for i in $(seq 1 10); do
	{ time $terminal -e sh -c "exit"; } 2>> $ftime
done

awk '/real/ {
  match($2, /([0-9]+)m([0-9.]+)s/, t);
  sec = t[1] * 60 + t[2];
  sum += sec;
  sumsq += sec^2;
  n++;
}
END {
  avg = sum / n;
  std = sqrt(sumsq / n - avg^2);
  printf "Runs: %d\nAverage: %.4f s\nStdDev: %.4f s\n", n, avg, std
}' $ftime

rm $ftime
