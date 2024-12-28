import asyncio
import websockets
import json
import sys

async def send_js_code(uri, script):
    async with websockets.connect(uri) as websocket:
        js_code = {
            "id": 1,
            "method": "Runtime.evaluate",
            "params": {
                "expression": script
            }
        }
        await websocket.send(json.dumps(js_code))
        response = await websocket.recv()

async def main(uri):
    with open('info/id.txt', 'r') as file:
        id_value = file.read().strip()

    scripts = [
        f"window.location.replace('https://x.com/{id_value}/followers')"
    ]

    for script in scripts:
        await send_js_code(uri, script)
        await asyncio.sleep(1)

if __name__ == "__main__":
    with open("./temp/debug_url.txt") as f: websocket_url = f.read().strip()
    asyncio.run(main(websocket_url))
