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
    # 点击第一个按钮：.btn.btn-sm.p-0.w-9.h-9
    while True:
        while True:
            exists = await send_js_code(uri, "document.querySelector('.btn.btn-sm.p-0.w-9.h-9') != null")
            if exists["result"]["result"]["value"]:
                break
            await asyncio.sleep(0.1)
        await send_js_code(uri, "document.querySelector('.btn.btn-sm.p-0.w-9.h-9').click();")
        break


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


    # 点击复选框 .checkbox（按之前检测元素是否存在）
    while True:
        exists = await send_js_code(uri, "document.querySelector('.checkbox') != null")
        if exists["result"]["result"]["value"]:
            break
        await asyncio.sleep(0.1)
    checkbox_status = (await send_js_code(uri, "document.querySelector('.checkbox').checked"))["result"]["result"]["value"]
    if checkbox_status == False:
        while True:
            await asyncio.sleep(0.1)
            await send_js_code(uri, "document.querySelector('.checkbox').click();")
            break


    # 点击按钮 .btn.btn-primary
    while True:
        while True:
            exists = await send_js_code(uri, "document.querySelector('.btn.btn-primary') != null")
            if exists["result"]["result"]["value"]:
                break
            await asyncio.sleep(0.1)
        await send_js_code(uri, "document.querySelector('.btn.btn-primary').click();")
        break


    # 点击第12个复选框 .checkbox.checkbox-sm（索引11）
    while True:
        while True:
            exists = await send_js_code(uri, "document.querySelectorAll('.checkbox.checkbox-sm')[11] != undefined")
            if exists["result"]["result"]["value"]:
                break
            await asyncio.sleep(0.1)
        await send_js_code(uri, "document.querySelectorAll('.checkbox.checkbox-sm')[11].click();")
        break


    # 点击第二个按钮 .btn.btn-primary（索引1）
    while True:
        while True:
            exists = await send_js_code(uri, "document.querySelectorAll('.btn.btn-primary')[1] != undefined")
            if exists["result"]["result"]["value"]:
                break
            await asyncio.sleep(0.1)
        await send_js_code(uri, "document.querySelectorAll('.btn.btn-primary')[1].click();")
        break


    # 点击第二个按钮 .btn.btn-sm.p-0.w-9.h-9（索引1）
    while True:
        while True:
            exists = await send_js_code(uri, "document.querySelectorAll('.btn.btn-sm.p-0.w-9.h-9')[1] != undefined")
            if exists["result"]["result"]["value"]:
                break
            await asyncio.sleep(0.1)
        await send_js_code(uri, "document.querySelectorAll('.btn.btn-sm.p-0.w-9.h-9')[1].click();")
        break


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


    # 点击复选框 document.querySelectorAll('.checkbox')[12]（按之前检测元素是否存在）
    while True:
        exists = await send_js_code(uri, "document.querySelectorAll('.checkbox')[12] != undefined")
        if exists["result"]["result"]["value"]:
            break
        await asyncio.sleep(0.1)
    checkbox_status_following = (await send_js_code(uri, "document.querySelectorAll('.checkbox')[12].checked"))["result"]["result"]["value"]
    if checkbox_status_following == False:
        await asyncio.sleep(0.1)
        await send_js_code(uri, "document.querySelectorAll('.checkbox')[12].click();")


    # 点击第三个按钮 .btn.btn-primary（索引2）
    while True:
        while True:
            exists = await send_js_code(uri, "document.querySelectorAll('.btn.btn-primary')[2] != undefined")
            if exists["result"]["result"]["value"]:
                break
            await asyncio.sleep(0.1)
        await send_js_code(uri, "document.querySelectorAll('.btn.btn-primary')[2].click();")
        break


    # 点击第24个复选框 .checkbox.checkbox-sm（索引23）
    while True:
        while True:
            exists = await send_js_code(uri, "document.querySelectorAll('.checkbox.checkbox-sm')[23] != undefined")
            if exists["result"]["result"]["value"]:
                break
            await asyncio.sleep(0.1)
        await send_js_code(uri, "document.querySelectorAll('.checkbox.checkbox-sm')[23].click();")
        break


    # 点击第四个按钮 .btn.btn-primary（索引3）
    while True:
        while True:
            exists = await send_js_code(uri, "document.querySelectorAll('.btn.btn-primary')[3] != undefined")
            if exists["result"]["result"]["value"]:
                break
            await asyncio.sleep(0.1)
        await send_js_code(uri, "document.querySelectorAll('.btn.btn-primary')[3].click();")
        break


if __name__ == "__main__":
    with open('./temp/debug_url.txt', 'r') as file:
        websocket_url = file.read().strip()
    asyncio.run(main(websocket_url))
