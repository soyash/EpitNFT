from brownie import EpicNFT, accounts, network, config
import json, requests, random, base64

def getAccount():
    if network.show_active() == 'development':
        return accounts[0]
    else:
        return accounts.add(config["wallets"]["from_key"])

def getTokenUri():
    url = "https://api.pinata.cloud/pinning/pinJSONToIPFS"

    firstWord = ["flying", "swimming", "walking", "sitting", "standing", "sleeping"]
    secondWord = ["moneky", "squirel", "shark", "lion", "dog", "penguin"]
    thirdWord = ["swims", "walks", "sits", "stands", "sleeps", "flies"]
    colors = ["black", "#625D5D", "#000080", "#00CED1", "#FFD700", "#B87333", "#3B2F2F", "#FF6700", "#FF2400", "#F6358A", "#FF00FF"]

    randomFirstWord = random.choice(firstWord)
    randomSecondWord = random.choice(secondWord)
    randomThirdWord = random.choice(thirdWord)
    combinedWord = randomFirstWord + randomSecondWord + randomThirdWord

    SVG = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='" + random.choice(colors) + "' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>" + randomFirstWord + randomSecondWord + randomThirdWord + "</text></svg>"
    SVG = SVG.encode("ascii")
    SVG = base64.b64encode(SVG)

    json_payload = '{"name": "' + combinedWord + '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,' + str(SVG) + '"}'

    json_payload = json_payload.encode("ascii")
    json_payload = str(base64.b64encode(json_payload))

    final_payload = "data:application/json;base64," + json_payload

    payload = json.dumps(
        {
            "pinataMetadata": {"name": combinedWord},
            "pinataContent": {combinedWord: final_payload}
        }
    )

    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer {0}'.format(config["pinata"]["JWT"])
    }

    response = requests.request("POST", url, headers=headers, data=payload)
    response = json.loads(response.text)

    tokenUri = response['IpfsHash']
    tokenUri = requests.get('ipfs://{0}'.format(tokenUri))
    tokenUri = tokenUri[combinedWord]

    return tokenUri



def functionality_test():
    account = getAccount()
    tokenUri = getTokenUri()
    enft = EpicNFT.deploy({'from':account})
    tx = enft.makeAnEpicNFT(tokenUri, {'from':account})
    print(tx.events)


def main():
    functionality_test()