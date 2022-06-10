import Foundation

public class Tile: Identifiable, Codable, Equatable {
    public let id: String
    public let type: String

    public init(id: String, type: String) {
        self.id = id
        self.type = type
    }

    public static func == (lhs: Tile, rhs: Tile) -> Bool {
        lhs.id == rhs.id
    }
}

public struct TileResponse: Codable {
    public enum CodingKeys: CodingKey { case id, token, tiles }
    public enum ObjectTypeKey: CodingKey { case type }

    public let id: String?
    public let token: String?
    public let tiles: [Tile]

    public static let moduleName = String(reflecting: TileResponse.self).prefix{$0 != "."}

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.token = try container.decodeIfPresent(String.self, forKey: .token)
        var rawTiles = try container.nestedUnkeyedContainer(forKey: .tiles)
        self.tiles = try TileDecoder().decodeMultipleTiles(from: &rawTiles)
    }
}

public struct CreatePostResponse: Codable {
    public enum CodingKeys: CodingKey { case tile }
    public enum ObjectTypeKey: CodingKey { case type }

    public let tile: Tile?

    public static let moduleName = String(reflecting: CreatePostResponse.self).prefix{$0 != "."}

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let tileTypeContainer = try container.nestedContainer(keyedBy: ObjectTypeKey.self, forKey: .tile)
        let type: String = try tileTypeContainer.decode(String.self, forKey: .type)
        guard let className = Bundle.main.classNamed("\(CreatePostResponse.moduleName).\(type)") as? Tile.Type else {
            self.tile = nil
            return
        }
        // GOES WRONG HERE. Should decode into MediaTile, but ends up being a Tile.
        self.tile = try container.decode(className, forKey: .tile)
    }
}

public final class MediaTile: Tile, PostTile {
    public enum CodingKeys: CodingKey { case author, createdDate, text, reactions, topComment, images, seeAllCommentsAction }

    public let author: Author
    public let createdDate: String
    public let text: String?
    public let reactions: PostReactions
    public let topComment: Comment?
    public let images: [TileImage]?
    public let seeAllCommentsAction: DeeplinkAction?

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        author = try container.decode(Author.self, forKey: .author)
        createdDate = try container.decode(String.self, forKey: .createdDate)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        reactions = try container.decode(PostReactions.self, forKey: .reactions)
        topComment = try container.decodeIfPresent(Comment.self, forKey: .topComment)
        images = try container.decodeIfPresent([TileImage].self, forKey: .images)
        seeAllCommentsAction = try container.decodeIfPresent(DeeplinkAction.self, forKey: .seeAllCommentsAction)
        try super.init(from: decoder)
    }
}


public protocol PostTile: Tile {
    var author: Author { get }
    var createdDate: String { get }
    var text: String? { get }
    var reactions: PostReactions { get }
    var topComment: Comment? { get }
    var seeAllCommentsAction: DeeplinkAction? { get }
}

public struct Author: Codable {
    let id: String
    let title: AuthorTitle
    let avatar: Avatar

    struct AuthorTitle: Codable {
        let text: String
        let actions: [AuthorTitleActions]?
    }

    struct AuthorTitleActions: Codable {
        let id: String
        let text: String
        let action: URL
    }

    struct Avatar: Codable {
        let color: String?
        let title: String?
        let image: URL?
        let badge: Badge?
        let id: String

        struct Badge: Codable {
            let url: URL?
            let id: String
        }
    }
}

public struct PostReactions: Codable {
    var topReactions: [Reaction]
    var myReaction: String?
    var profiles: [ReactionProfile]

    public struct Reaction: Codable {
        let type: String
        let id: String
        let title: String
    }

    public struct ReactionProfile: Codable {
        let id: String
        let name: String
    }
}

public struct Comment: Codable, Identifiable {
    public let id: String
    public let author: CommentAuthor
    public let createdDate: Date
    public let text: String
    public let noOfLikes: Int
    public let isLiked: Bool

    public struct CommentAuthor: Codable {
        let id: String
        let displayName: String
        let avatar: Author.Avatar
    }
}

public struct DeeplinkAction: Codable {
    public let title: String
    public let action: URL
}

public struct Reactions: Codable {
    public let count: Int
    public let userLiked: Bool
 }

public struct TileImage: Codable, Identifiable {
    public let url: URL
    public let id: String
}
