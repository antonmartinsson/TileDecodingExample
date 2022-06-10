import Foundation

public struct TileDecoder {
    public enum ObjectTypeKey: CodingKey { case type }

    public func decodeMultipleTiles(from unkeyedDecodingContainer: inout UnkeyedDecodingContainer) throws -> [Tile] {
        var rawTilesCopy = unkeyedDecodingContainer
        var parsedTiles: [Tile] = []

        while !unkeyedDecodingContainer.isAtEnd {
            let tileTypeContainer = try unkeyedDecodingContainer.nestedContainer(keyedBy: ObjectTypeKey.self)
            let type = try tileTypeContainer.decode(String.self, forKey: .type)

            if let className = Bundle.main.classNamed("\(TileResponse.moduleName).\(type)") as? Tile.Type {
                do {
                    let tile = try rawTilesCopy.decode(className)
                    parsedTiles.append(tile)
                } catch {
                    print(error.localizedDescription)
                }

            }
            rawTilesCopy = unkeyedDecodingContainer
        }
        return parsedTiles
    }
}
