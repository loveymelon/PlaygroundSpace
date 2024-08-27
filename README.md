# WorkSpace 

<img src= "https://github.com/user-attachments/assets/4bbdc304-57d2-4f59-ae4f-75ec5884a2ea">

## 앱의 기능

- 멤버 관리 
  * SNS(Apple, 카카오톡 등), 이메일 회원가입 및 로그인
  * 프로필 설정, 프로필 조회

- 워크스페이스

  * 주제별 워크스페이스 생성, 삭제, 편집, 관리자 양도, 멤버 초대 기능 (관리자 모드)
  * 워크스페이스의 채널별 실시간 단체 채팅 지원, 워크스페이스 멤버간 실시간 1:1 채팅 지원(메세지 당 이미지 5개 이하, 파일 첨부 기능)

| 로그인 화면 | 채널 세팅 | 사이드 메뉴 |
|:---:|:---:|:---:|
|<picture><img src="https://github.com/user-attachments/assets/6baa7ab2-cc33-479d-b3f9-33eed608ce9b" width="200" height="440"/></picture>| <picture><img src="https://github.com/user-attachments/assets/024173bf-d79b-4c2f-a274-e6a8d7623c21" width="200" height="440"/></picture>|<picture><img src="https://github.com/user-attachments/assets/151eb588-2012-4f84-b9d9-11cc3001516d" width="200" height="440"/></picture>|

| 채널 관리자 변경 및 나가기 | 개인 채팅 | 단체 채팅 |
|:---:|:---:|:---:|
|<picture><img src="https://github.com/user-attachments/assets/76f40a03-e511-45f6-a670-90ca644d9667" width="200" height="440"/></picture>| <picture><img src="https://github.com/user-attachments/assets/f8ad8b35-3cf5-4c23-9585-6dcdbe245231" width="200" height="440"/></picture>|<picture><img src="https://github.com/user-attachments/assets/932f562a-9caa-48bc-bb86-3a8cec78321e" width="200" height="440"/></picture>|

### 기술 스택

- SwiftUI, The Composable Architecture(TCA), TCACoordinator
- Alamofire, Socket.IO
- Kingfisher
- Alamofire
- MVI

# 기술설명
### SwiftUI + The Composable Architecture(TCA)
> 기존에 사용하였던 ContainerProtocol를 통해 상태 관리와 이벤트 처리의 일관된 인터페이스를 제공의 이점과 비즈니스 로직을 작은 단위로 나누어 모듈화하고, 이를 쉽게 재사용할 수 있는 이점이 있어 사용하였습니다.

### Feature 구성시
>State, Action을 구성시 공통되는 특징을 지닌 Action, State들을 하나의 타입으로 정의하고,
하위에서 상위로 제공할땐 Delegate를 통해서만 값을 전달하며 상위에서 하위한테 값 전달시에는 ParentAction타입으로 정의하여서 가독성을 높였습니다.

```swift
@Reducer
struct ChannelOwnerFeature {
    @ObservableState
    struct State: Equatable {
        var channelId: String
        var memberInfo: [MemberInfoEntity] = []
        var beforeViewType: BeforeViewType
    }
    
    enum BeforeViewType {
        case channel
        case sideMenu
    }
    
    enum Action {
        case viewEventType(ViewEventType)
        case dataTransType(DataTransType)
        case networkType(NetworkType)
        
        case delegate(Delegate)
        enum Delegate {
            case backButtonTapped
           ...
        }
    }
    
    enum ViewEventType {
        case onAppear
       ...
    }
    
    enum DataTransType {
        case memberInfo([MemberInfoEntity])
    }
    
    enum NetworkType {
        case fetchChannelMember
        ...
    }
    
    private let repository = ChannelOwnerRepository()
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                ...
            default:
                break
            }
            return .none
        }
    }
}


```

### Subscript
> safe subscript를 구현함으로써 얻을 수 있는 이점은 안전한 인덱스 접근과 코드의 가독성 및 간결성을 가져와 컬렉션에 존재하지 않는 인덱스에 접근할 때 발생할 수 있는 오류를 방지하며, 보다 안전하고 직관적인 코드를 작성하였습니다.

```swift
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
```

### Swift Concurrency
> WWDC 2021에 등장한 GCD기반인 Concurrency는 async/await를 통해 비동기 작업을 동기 코드처럼 직관적이고 간결하게 작성할 수 있고 복잡한 콜백 체인을 피하여 콜백 지옥을 방지할 수 있습니다.
하나의 actor가 siral인 스레드이므로 gcd처럼 개발자가 원치않는 스레드 할당(Thread Explosion Prevention)을 방지합니다.
```swift
 func requestNetwork<T: DTO, R: Router>(dto: T.Type, router: R) async throws -> Result<T, APIError> {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                let request = try router.asURLRequest()
                    
                    AF.request(request, interceptor: NetworkInterceptor.shared)
                        .responseDecodable(of: T.self) { result in
                            switch result.result {
                            case .success(let data):
                                continuation.resume(returning: .success(data))
                            case .failure(_):
                                guard let data = result.data else { return }
                                let errorResult = JSONManager.shared.decoder(type: ErrorDTO.self, data: data)
                                switch errorResult {
                                case .success(let success):
                                    continuation.resume(returning: .failure(.httpError(success.errorCode)))
                                case .failure(let failure):
                                    print(failure)
                                }
                            }
                        }
                    
                
            } catch {
                print(error)
            }
        }
    }
```

## 트러블 슈팅

### RaceCondition
>토큰 요청시 동시에 여러 네트워크 요청이 이루어질 때, 모든 요청이 동일한 토큰을 사용해야 하는데, 토큰 갱신 중에 다른 요청이 발생할 경우 Race Condition이 발생하였습니다.

>retryRequests을 통해 serial같은 성격으로 요청 큐를 관리하였습니다. 그래서 하나의 작업이 성공하면 나머지 작업들도 성공처리로 해결을 하였습니다.<br>
RetryLimit으로 무한 요청을 하는 것을 방지하며 토큰 요청이 실패시 사용자에게 로그아웃 또는 재로그인으로 유도하였습니다.

```swift
final class NetworkInterceptor: RequestInterceptor {
    
    @Dependency(\.networkManager) var network
    
    static let shared = NetworkInterceptor()
    
    private init() { }
    
    private let retryLimit = 3
    private var retryRequests: [(RetryResult) -> Void] = []
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        
        var modifiedURLRequest = urlRequest
        modifiedURLRequest.setValue(UserDefaultsManager.shared.accessToken, forHTTPHeaderField: HeaderType.auth)
        completion(.success(modifiedURLRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        
        retryRequests.append(completion)
        
        if request.retryCount < retryLimit {
            network.refreshNetwork { [weak self] isValid in
                guard let self else { return }
                if isValid {
                    retryRequests.forEach { $0(.retry) }
                    retryRequests.removeAll()
                } else {
                    UserDefaultsManager.shared.accessToken = ""
                    NotificationCenter.default.post(name: .refreshTokenDie, object: nil)
                    retryRequests.removeAll()
                    completion(.doNotRetryWithError(error))
                }
            }
        } else {
            UserDefaultsManager.shared.accessToken = ""
            NotificationCenter.default.post(name: .refreshTokenDie, object: nil)
            retryRequests.removeAll()
            completion(.doNotRetryWithError(error))
        }
    }
}


```

### Background 고려 

> 백그라운드로 변경시 소켓이 끊기지 않는 이슈가 있었습니다.
<br>소켓 init될 때 Background 시점을 찾아서 소켓을 끊고 Foreground시점에서 다시 연결해주도록 구성하였습니다.

```swift
extension SocketIOManager {
    private func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(suspendSocket), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(restartSocket), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
}

extension SocketIOManager {
    @objc
    private func suspendSocket() {
        stopSocket()
    }
    
    @objc
    private func restartSocket() {
        startSocket()
    }
}

```
