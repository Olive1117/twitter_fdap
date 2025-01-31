import asyncio
import websockets
import json

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
        return json.loads(response)

async def main(uri):
    await send_js_code(uri, "document.querySelector('.btn.btn-sm.p-0.w-9.h-9').click();")
    await asyncio.sleep(1)

    while True:
        response_followers = await send_js_code(
            uri,
            "parseInt(document.querySelector('div.mt-3.flex.items-center.gap-2').textContent.match(/of (\\d+) items/)[1]);"
        )
        followers_count = (await send_js_code(uri, "parseInt(document.querySelector('.flex.flex-col.flex-grow .text-sm')?.innerText?.trim());")).get("result", {}).get("result", {}).get("value")
        if followers_count == 0:
            break
        elif response_followers["result"]["result"]["value"] != 0:
            break
        await asyncio.sleep(1)

    checkbox_status = (await send_js_code(uri, "document.querySelector('.checkbox').checked"))["result"]["result"]["value"]

    if checkbox_status == False:
        await send_js_code(uri, "document.querySelector('.checkbox').click();")
        await asyncio.sleep(1)

    await send_js_code(uri, "document.querySelector('.btn.btn-primary').click();")
    await asyncio.sleep(1)

    await send_js_code(uri, "document.querySelectorAll('.btn.btn-primary')[1].click();")
    await asyncio.sleep(1)

    await send_js_code(uri, "document.querySelectorAll('.btn.btn-sm.p-0.w-9.h-9')[1].click();")
    await asyncio.sleep(1)

    while True:
        response_following = await send_js_code(
            uri,
            "parseInt(document.querySelectorAll('div.mt-3.flex.items-center.gap-2')[1].textContent.match(/of (\\d+) items/)[1]);"
        )
        following_count = (await send_js_code(uri, "parseInt(document.querySelectorAll('.flex.flex-col.flex-grow .text-sm')[1].innerText.trim());")).get("result", {}).get("result", {}).get("value")
        if following_count == 0:
            break
        elif response_following["result"]["result"]["value"] != 0:
            break
        await asyncio.sleep(1)

    checkbox_status_following = (await send_js_code(uri, "document.querySelectorAll('.checkbox')[12].checked"))["result"]["result"]["value"]
    if checkbox_status_following == False:
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
