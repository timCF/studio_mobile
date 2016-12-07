all:
	git submodule update --init --recursive
	lsc --compile --const ./app.ls ./index.ios.ls ./index.android.ls
	mv ./index.ios ./index.ios.js
	mv ./index.android ./index.android.js
	value=`cat ./app/studio_proto/studio.proto` && echo "module.exports = \"\"\"\n$$value\n\"\"\"" > ./app/sproto.ls
	rm -rf ./app/js && mkdir ./app/js
	pushd ./app && lsc --compile --const ./*.ls && mv ./*.js ./js/ && rm ./sproto.ls && popd
