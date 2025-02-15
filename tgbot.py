import asyncio
from telegram import Bot
from telegram.constants import ParseMode

def get_token_and_user_id():
    with open('./info/tgapikey.txt', 'r') as token_file:
        token = token_file.read().strip()
    with open('./info/tguserid.txt', 'r') as user_id_file:
        user_id = int(user_id_file.read().strip())
    return token, user_id

async def send_file_content(bot, user_id):
    try:
        with open('./diff.md', 'r') as file:
            content = file.read()

        await bot.send_message(
            chat_id=user_id,
            text=content,
            parse_mode=ParseMode.MARKDOWN
        )
        print("File content sent successfully!")
    except Exception as e:
        print(f"Error: {e}")

async def main():
    token, user_id = get_token_and_user_id()
    bot = Bot(token=token)
    await send_file_content(bot, user_id)

if __name__ == '__main__':
    asyncio.run(main())
