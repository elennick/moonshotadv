local:
		/Applications/love.app/Contents/MacOS/love .

web: web-build
		open -a "Google Chrome" "http://localhost:8000"
		pushd ~/Development/moonshotadv/build; python -m SimpleHTTPServer 8000

clean:
		rm -rf ~/Development/moonshotadv/build

web-build: clean
		love-js ~/Development/moonshotadv ~/Development/moonshotadv/build -t 'Super Moonshot Adventure' -m 200000000

web-zip: clean web-build
		zip -r build/moonshotadventure.zip build
