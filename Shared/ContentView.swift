//
//  ContentView.swift
//  Shared
//
//  Created by Anton Martinsson on 2022-06-10.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        let data = exampleJson.data(using: .utf8)
        let response: CreatePostResponse = try! JSONDecoder().decode(CreatePostResponse.self, from: data!)
        if response.tile is MediaTile {
            Text("Tile is right type! :D")
        } else {
            Text("Tile is not right type :(")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

public let exampleJson: String =
"""
{
    "tile": {
        "type": "MediaTile",
        "id": "88ca3099-cfbd-4238-9680-ecc957ae27b8",
        "createdDate": "2022-06-08T13:16:51.568Z",
        "author": {
            "id": "88ca3099-cfbd-4238-9680-ecc957ae27b8",
            "title": {
                "text": "**[Anton Martinsson](https://app-staging.waroncancer.com/profiles/5510?source=community-feed&context=community-feed)**"
            },
            "avatar": {
                "image": "https://wocimages.blob.core.windows.net/wocstgimages/1654609686436-ZmlsZS5qcGVn.jpeg",
                "color": "secondaryCancerAvatar",
                "title": "A",
                "id": "b8dfcacc-2d13-4fa7-8941-6393e30b0ad6",
                "action": "https://app-staging.waroncancer.com/profiles/5510?source=community-feed&context=community-feed"
            }
        },
        "mentions": [],
        "reactions": {
            "topReactions": [],
            "myReactions": [],
            "myReaction": "",
            "otherUsers": [],
            "profiles": [],
            "action": "https://app-staging.waroncancer.com/posts/88ca3099-cfbd-4238-9680-ecc957ae27b8/reactions",
            "topReactionTypes": []
        },
        "seeAllCommentsAction": {
            "title": "View all undefined comments",
            "action": "https://app-staging.waroncancer.com/posts/88ca3099-cfbd-4238-9680-ecc957ae27b8"
        },
        "text": "Sorry for da spam",
        "images": null
    }
}
"""
