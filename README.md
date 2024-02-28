# AnimeGen

AnimeGen is an app made in Swift. This app is developed using public APIs. The app purpose is to save, generate, and share images.

## Compatibility
AnimeGen supports any iOS/iPadOS device running iOS 13+

## APIs
<table>
<tr>
        <th>Working APIs</th>
</tr>
<tr><td>
        
| APIs                | Type  | Working |
| ------------------- | ----- | :--------: |
| Pic.re              | SFW      |   :white_check_mark:       |
| Waifu.im            | SFW/NSFW |   :white_check_mark:       |
| Nekos.best          | SFW      |   :white_check_mark:       |
| Waifu.pics          | SFW/NSFW |   :white_check_mark:       |
| Hmtai               | SFW/NSFW |   :warning:                |
| Nekos api           | SFW/NSFW |   :white_check_mark:       |
| Nekos.mod           | SFW/NSFW |   :white_check_mark:       |

</table>

> [!Important]
> The Hmtai api uses "cdn.discordapp.com/attachments" links, they are currently marked as "This content is no longer available.", so most of the images wont work.

## APIs Credits

- [pic.re api](https://doc.pic.re/)
- [waifu.im api](https://docs.waifu.im/)
- [nekos.best api](https://docs.nekos.best/)
- [waifu.pics api](https://waifu.pics/docs)
- [Hmtai api](https://hmtai.hatsunia.cfd/endpoints)
- [Nekos api](https://nekosapi.com/docs)
- [Nekos.moe](https://docs.nekos.moe)

## Third Party Softwares

- [SDWebImage](https://github.com/SDWebImage/SDWebImage) (.gif images saves for the gallery)

## Help

- [NineAnimator](https://github.com/SuperMarcus/NineAnimator) (Launchscreen Idea/Base)
- [Nekidev](https://github.com/Nekidev/anime-api) (Anime-api list)
- [Jared Davidson](https://www.youtube.com/@Archetapp) (AppIcon change)




## Build

Want to build the app yourself? No problem, by cloning this repo and running the ipadbuild.sh file, you can build your own IPA of the app! You can also modify the app as you like!

Clone the repo:

```
git clone https://github.com/cranci1/AnimeGen
```

Navige to the directory:

```
cd AnimeGen
```

Run the script:

```
./ipabuild.sh
```

If the build was successful, you should see a "build" folder with a subfolder "DerivedDataApp" and the AnimeGen.ipa file in the AnimeGen directory. You are now done! Just use any IPA installer like TrollStore, AlStore, Scarlet, ESign or sideloadly to install the IPA on the desired device.
