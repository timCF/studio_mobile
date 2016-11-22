all:
	git submodule update --init --recursive
	lsc --compile --const ./index.ios.ls
	mv ./index.ios ./index.ios.js
	value=`cat ./app/studio_proto/studio.proto` && echo "module.exports = \"\"\"\n$$value\n\"\"\"" > ./app/sproto.ls
	rm -rf ./app/js && mkdir ./app/js
	pushd ./app && lsc --compile --const ./*.ls && mv ./*.js ./js/ && rm ./sproto.ls && popd
