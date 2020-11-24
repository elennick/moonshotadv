runlocal:
		/Applications/love.app/Contents/MacOS/love .

runweb:
		love-js . build/ -t 'Super Moonshot Adventure' -c -m 100000000
		rm -rf build/
		python -m SimpleHTTPServer 8000
