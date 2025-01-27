import asyncio
import websockets
import json

# Function to send JS code to the browser and receive the response
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
        return json.loads(response)  # Parse the response into JSON

async def main(uri):
    # Execute the first command
    await send_js_code(uri, "document.querySelector('.btn.btn-sm.p-0.w-9.h-9').click();")
    await asyncio.sleep(1)  # Wait for 1 second

    # First while True loop
    while True:
        response_followers = await send_js_code(
            uri,
            "parseInt(document.querySelector('div.mt-3.flex.items-center.gap-2').textContent.match(/of (\\d+) items/)[1]);"
        )
        if response_followers["result"]["result"]["value"] != 0:
            break
        await asyncio.sleep(0.5)

    # Execute other commands
    await send_js_code(uri, "document.querySelector('.checkbox').click();")
    await asyncio.sleep(1)

    await send_js_code(uri, "document.querySelector('.btn.btn-primary').click();")
    await asyncio.sleep(1)

    await send_js_code(uri, "document.querySelectorAll('.btn.btn-primary')[1].click();")
    await asyncio.sleep(1)

    # Execute the next command
    await send_js_code(uri, "document.querySelectorAll('.btn.btn-sm.p-0.w-9.h-9')[1].click();")
    await asyncio.sleep(1)

    # Second while True loop
    while True:
        response_following = await send_js_code(
            uri,
            "parseInt(document.querySelectorAll('div.mt-3.flex.items-center.gap-2')[1].textContent.match(/of (\\d+) items/)[1]);"
        )
        if response_following["result"]["result"]["value"] != 0:
            break
        await asyncio.sleep(0.5)

    # Execute subsequent commands
    await send_js_code(uri, "document.querySelectorAll('.checkbox')[12].click();")
    await asyncio.sleep(1)

    await send_js_code(uri, "document.querySelectorAll('.btn.btn-primary')[2].click();")
    await asyncio.sleep(1)

    await send_js_code(uri, "document.querySelectorAll('.btn.btn-primary')[3].click();")
    await asyncio.sleep(1)

if __name__ == "__main__":
    with open('./temp/debug_url.txt', 'r') as file:
        websocket_url = file.read().strip()
    asyncio.run(main(websocket_url))
