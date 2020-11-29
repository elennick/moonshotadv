local:
		/Applications/love.app/Contents/MacOS/love .

web: web-build
		open -a "Google Chrome" "http://localhost:8000"
		pushd ~/Development/moonshotadv/build; python -m SimpleHTTPServer 8000

web-clean:
		rm -rf ~/Development/moonshotadv/build

web-build: web-clean
		love-js ~/Development/moonshotadv ~/Development/moonshotadv/build -t 'Super Moonshot Adventure' -m 200000000
		cp ~/Development/moonshotadv/web/index.html ~/Development/moonshotadv/build/

web-zip: web-clean web-build
		zip -r build/moonshotadventure.zip build
