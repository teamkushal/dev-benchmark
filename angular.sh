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
git stash save --include-untracked
npm install yarn --global
npm install ts-node --global
npm install @angular/cli --global

echo >> $f
echo "### $1" >> $f
echo >> $f

# --------- create an Angular webapp for benchmarking.

echo "#### Angular" >> $f
echo >> $f
echo "- create" >> $f
setStartTime
time ng new benchmark1 --package-manager=yarn --routing=true --strict=true --style=scss --verbose=true --verbos=true --view-encapsulation=ShadowDom 
logEnd

cd benchmark1
echo "- build" >> ../$f
setStartTime
npm run ng build --prod
logEnd2

cd ..
clean
