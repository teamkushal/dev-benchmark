#!/usr/bin/bash
f=README.md
setStartTime () {
  start=$(node -e 'a=new Date(); console.log(`${+a/1000}`)')
}
logEnd () {
  echo $(echo "$(node -e 'a=new Date(); console.log(`${+a/1000}`)') - $start" | bc) > temp && tail -n 3 temp | head -1 >> $f
}
logEnd2 () {
  echo $(echo "$(node -e 'a=new Date(); console.log(`${+a/1000}`)') - $start" | bc) > temp && tail -n 3 temp | head -1 >> ../$f
}
clean () {
  rm -rf benchmark1 > temp
  rm -rf benchmark2 > temp
  rm temp
}

clean
git stash save -u
npm install yarn -g
npm install ts-node -g
npm install create-react-app -g
npm install express-generator-typescript -g

echo >> $f
echo "### $1" >> $f
echo >> $f

# --------- create an CRA webapp for benchmarking.

echo "#### CRA" >> $f
echo >> $f
echo "- create" >> $f
setStartTime
npx create-react-app benchmark1 --template typescript
logEnd

cd benchmark1
echo "- build" >> ../$f
setStartTime
npm run build
logEnd2

echo "- run tests" >> ../$f
setStartTime
CI=true npm run test
logEnd2

cd ..
clean

# --------- create an Express NodeJS app for benchmarking.

echo >> $f
echo "#### express" >> $f
echo >> $f
echo "- create" >> $f
setStartTime
npx express-generator-typescript --with-auth benchmark2
logEnd

cd benchmark2
echo "- build" >> ../$f
setStartTime
npm run build
logEnd2

echo "- run tests" >> ../$f
setStartTime
npx ts-node -r tsconfig-paths/register ./spec
logEnd2

cd ..
clean
