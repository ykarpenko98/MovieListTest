// swiftlint:disable line_length large_tuple
import XCTest
@testable import MovieList

class DetailsViewModelTests: XCTestCase {

    func test_DetailsMovie_InitialLoad() {
        let delegate = SpyDetailsViewModelDelegate()
        let sut = DetailsViewModel(movie:
                                    MovieViewModel(id: 100, title: "Title", genres: "Genres", rate: 8.9, overview: "Overview", posterImagePath: nil, cast: "Cast")
        )

        sut.delegate = delegate

        sut.didLoad()

        XCTAssertEqual(delegate.updateWithSnapshotArr.count, 1)
        let element = delegate.updateWithSnapshotArr[0]
        XCTAssertEqual(element.title, "Title")
        XCTAssertEqual(element.rateTitle, "8.9 🏆")
        XCTAssertEqual(element.snapshot.itemIdentifiers, [
            .image(imagePath: nil),
            .text(title: "Overview", description: "Overview"),
            .text(title: "Cast", description: "Cast")
        ])
    }
}

private class SpyDetailsViewModelDelegate: DetailsViewModelDelegate {
    var updateWithSnapshotArr: [(snapshot: DetailsViewSnapshot, title: String, rateTitle: String)] = []
    func updateWithSnapshot(snapshot: DetailsViewSnapshot, title: String, rateTitle: String) {
        updateWithSnapshotArr.append((snapshot: snapshot, title: title, rateTitle: rateTitle))
    }
}
