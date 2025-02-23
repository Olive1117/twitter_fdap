import asyncio
import websockets
import json
import os
import sys

async def send_js_code(uri, script):
    async with websockets.connect(uri) as websocket:
        js_code = {
            "id": 1,
            "method": "Runtime.evaluate",
            "params": {
                "expression": script,
                "returnByValue": True
            }
        }
        await websocket.send(json.dumps(js_code))
        response = await websocket.recv()
        response_json = json.loads(response)

        if 'result' in response_json and 'result' in response_json['result']:
            result = response_json['result']['result']
            if 'value' in result:
                return result['value']
        return None

async def monitor_page_cleardb(uri):
    js_code_cleardb = '''if (!window.scriptElement) {
    indexedDB.deleteDatabase('twitter-web-exporter');
}
'''
    await send_js_code(uri, js_code_cleardb)
    await asyncio.sleep(0.1)

async def monitor_page_er(uri):
    js_code_er = '''if (!window.scriptElement) {
                    const scriptElement = document.querySelector('script[data-testid="UserProfileSchema-test"]');
                    if (scriptElement) {
                        const jsonData = JSON.parse(scriptElement.innerText);
                        const interactionStat = jsonData.mainEntity.interactionStatistic.find(stat => stat.name === "Follows");
                        if (interactionStat) {
                            interactionStat.userInteractionCount;
                        } else {
                            null;
                        }
                    } else {
                        null;
                    }
                }'''
    while True:
        await asyncio.sleep(0.5)
        response_er = await send_js_code(uri, js_code_er)
        if response_er is not None:
            break

    await send_js_code(uri, "fetch(location.href, { cache: 'reload' }).then(() => location.reload());")

    while True:
        await asyncio.sleep(0.5)
        response_er = await send_js_code(uri, js_code_er)
        if response_er is not None:
            with open('./temp/target_number-1.txt', 'w') as file:
                file.write(str(response_er))
            break

async def monitor_page_ing(uri):
    await asyncio.sleep(0.5)
    js_code_ing = '''if (!window.scriptElement) {
                    const scriptElement = document.querySelector('script[data-testid="UserProfileSchema-test"]');
                    if (scriptElement) {
                        const jsonData = JSON.parse(scriptElement.innerText);
                        const interactionStat = jsonData.mainEntity.interactionStatistic.find(stat => stat.name === "Friends");
                        if (interactionStat) {
                            interactionStat.userInteractionCount;
                        } else {
                            null;
                        }
                    } else {
                        null;
                    }
                }'''
    response_ing = await send_js_code(uri, js_code_ing)
    with open('./temp/target_number-2.txt', 'w') as file:
        file.write(str(response_ing))

async def main():
    with open('./temp/debug_url.txt', 'r') as file:
        websocket_url = file.read().strip()

    await monitor_page_cleardb(websocket_url)
    await monitor_page_er(websocket_url)
    await monitor_page_ing(websocket_url)

if __name__ == "__main__":
    asyncio.run(main())
