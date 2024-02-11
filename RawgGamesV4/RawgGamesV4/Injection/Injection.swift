//
//  Injection.swift
//  RawgGamesV4
//
//  Created by Dhimas Dewanto on 08/02/24.
//

import Core
import Favorite
import Games

typealias GetGamesRepoType = GetGamesRepo<
    GetGamesRemoteSrc,
    GamesTransformer,
    GamesReqTranformer
>

typealias GetDetailGameRepoType = GetDetailGameRepo<
    GetDetailGameRemoteSrc,
    DetailGameTransformer
>

typealias GetFavoritesRepoType = GetFavoritesRepo<
    FavoriteLocalSrc,
    FavoriteTransformer
>

typealias AddFavoritesRepoType = AddFavoritesRepo<
    FavoriteLocalSrc,
    FavoriteTransformer
>

typealias RemoveFavoritesRepoType = RemoveFavoritesRepo<
    FavoriteLocalSrc
>

typealias GameUseCaseType = Interactor<
    GetGamesRepoType.Req,
    GetGamesRepoType.Res,
    GetGamesRepoType
>

typealias GetDetailGameUseCase = Interactor<
    GetDetailGameRepoType.Req,
    GetDetailGameRepoType.Res,
    GetDetailGameRepoType
>

typealias GetFavoritesUseCase = Interactor<
    GetFavoritesRepoType.Req,
    GetFavoritesRepoType.Res,
    GetFavoritesRepoType
>

typealias AddFavoritesUseCase = Interactor<
    AddFavoritesRepoType.Req,
    AddFavoritesRepoType.Res,
    AddFavoritesRepoType
>

typealias RemoveFavoritesUseCase = Interactor<
    RemoveFavoritesRepoType.Req,
    RemoveFavoritesRepoType.Res,
    RemoveFavoritesRepoType
>

final class Injection {
    /// Create singleton of`Injection`.
    static let shared: Injection = Injection()

    private init() {}

    // Create singleton of use case.
    //TODO: Should set like this
    //    func gameUseCase2<U: UseCase>() -> U where U.Req == GamesParams, U.Res == [GameModel] {
    //        return Injection.gameUseCase as! U
    //    }

    private static var gameUseCase: GameUseCaseType {
        let remote = GetGamesRemoteSrc()
        let repo = GetGamesRepo(
            getGamesSrc: remote,
            mapperRes: GamesTransformer(),
            mapperReq: GamesReqTranformer()
        )
        let interactor = Interactor(repo: repo)
        return interactor
    }
    private static var detailGameUseCase: GetDetailGameUseCase {
        let remote = GetDetailGameRemoteSrc()
        let repo = GetDetailGameRepo(
            getDetailGameSrc: remote,
            mapperRes: DetailGameTransformer()
        )
        let interactor = Interactor(repo: repo)
        return interactor
    }
    private static var getFavoritesUseCase: GetFavoritesUseCase {
        let manager = CoreDataManager.manager
        let local = FavoriteLocalSrc(
            manager: manager
        )
        let repo = GetFavoritesRepo(
            favoriteSrc: local,
            mapperRes: FavoriteTransformer()
        )
        let interactor = Interactor(repo: repo)
        return interactor
    }
    private static var addFavoritesUseCase: AddFavoritesUseCase {
        let manager = CoreDataManager.manager
        let local = FavoriteLocalSrc(
            manager: manager
        )
        let repo = AddFavoritesRepo(
            favoriteSrc: local,
            mapperReq: FavoriteTransformer()
        )
        let interactor = Interactor(repo: repo)
        return interactor
    }
    private static var removeFavoritesUseCase: RemoveFavoritesUseCase {
        let manager = CoreDataManager.manager
        let local = FavoriteLocalSrc(
            manager: manager
        )
        let repo = RemoveFavoritesRepo(
            favoriteSrc: local
        )
        let interactor = Interactor(repo: repo)
        return interactor
    }

    /// Get presenter for popular.
    func getPopular() -> PopularPresenter {
        return PopularPresenter(
            gameUseCase: Injection.gameUseCase
        )
    }

    /// Get presenter for favorite.
    func getFavorite() -> FavoritePresenter {
        return FavoritePresenter(
            getFavoritesUseCase: Injection.getFavoritesUseCase,
            addFavoritesUseCase: Injection.addFavoritesUseCase,
            removeFavoritesUseCase: Injection.removeFavoritesUseCase
        )
    }

    /// Get presenter for search games.
    func getSearch() -> SearchPresenter {
        return SearchPresenter(
            gameUseCase: Injection.gameUseCase
        )
    }

    /// Get presenter for detail game.
    func getDetail(game: GameModel) -> DetailPresenter {
        return DetailPresenter(
            gameUseCase: Injection.detailGameUseCase,
            game: game
        )
    }
}
