import requests
import random
import base64

def connectToPinata():
    baseURL = "https://api.pinata.cloud"


def create_svg():

    firstWord = ["flying", "swimming", "walking", "sitting", "standing", "sleeping"]
    secondWord = ["moneky", "squirel", "shark", "lion", "dog", "penguin"]
    thirdWord = ["swims", "walks", "sits", "stands", "sleeps", "flies"]
    colors = ["black", "#625D5D", "#000080", "#00CED1", "#FFD700", "#B87333", "#3B2F2F", "#FF6700", "#FF2400", "#F6358A", "#FF00FF"]

    randomFirstWord = random.choice(firstWord)
    randomSecondWord = random.choice(secondWord)
    randomThirdWord = random.choice(thirdWord)

    name = randomFirstWord + randomSecondWord + randomThirdWord

    SVG = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='" + random.choice(colors) + "' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>" + randomFirstWord + randomSecondWord + randomThirdWord + "</text></svg>"

    final_json = '{"name": "' + name + '", "description": "A highly acclaimed collection of squares.", "image": "' + SVG + '"}'
    final_json = final_json.encode("ascii")

    json_b64 = base64.b64encode(final_json)
    json_b64_string = json_b64.decode("ascii")

    final_token_uri = "data:application/json;base64," + json_b64_string

def main():
    create_svg()