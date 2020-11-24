runlocal:
		/Applications/love.app/Contents/MacOS/love .

runweb: clean
		love-js . build/ -t 'Super Moonshot Adventure' -c -m 200000000
		python -m SimpleHTTPServer 8000

clean:
		rm -rf build/
