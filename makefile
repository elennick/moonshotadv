local:
		/Applications/love.app/Contents/MacOS/love .

web: web-build
		open -a "Google Chrome" "http://localhost:8000"
		pushd ~/Development/moonshotadv/web-build; python -m SimpleHTTPServer 8000

web-clean:
		rm -rf ~/Development/moonshotadv/web-build

web-build: web-clean
		love-js ~/Development/moonshotadv ~/Development/moonshotadv/web-build -t 'Super Moonshot Adventure' -m 200000000
		cp ~/Development/moonshotadv/web/index.html ~/Development/moonshotadv/web-build/

web-zip: web-clean web-build
		zip -r web-build/moonshotadventure.zip web-build

release-build: release-clean
		love-release -M -W

release-clean:
		rm -rf ~/Development/moonshotadv/releases
