-- bettervoxel.d.luau — the BetterVoxel scripting API, generated from the live
-- engine's pinned model. Do not edit: regenerate with
--   cargo test -p bv_engine_core --features docgen --test api_surface
-- The syntax is Luau's current definition-file grammar (extern types),
-- validated in CI with luau-lsp analyze against a smoke script.
-- Vector3 is Luau's native vector (one type, two dialects; typeof says
-- "vector" — a recorded divergence), so it is an alias, not a class.
-- Signals are declared without payload generics; each member's fired
-- arguments ride its trailing comment.

export type Vector3 = vector

declare extern type BVScriptConnection with
    Connected: boolean
    function Disconnect(self): ()
end

declare extern type BVScriptSignal with
    function Connect(self, callback: (...any) -> ()): BVScriptConnection
    function Once(self, callback: (...any) -> ()): BVScriptConnection
    function Wait(self): ...any
end

declare extern type EnumItem with
    EnumType: string
    Name: string
    Value: number
end

declare extern type TweenInfo with
    DelayTime: number
    EasingDirection: EnumItem
    EasingStyle: EnumItem
    RepeatCount: number
    Reverses: boolean
    Time: number
end

declare extern type CFrame with
    function Inverse(self): CFrame
    function Lerp(self, goal: CFrame, alpha: number): CFrame
    LookVector: Vector3
    function PointToObjectSpace(self, point: Vector3): Vector3
    function PointToWorldSpace(self, point: Vector3): Vector3
    Position: Vector3
    RightVector: Vector3
    Rotation: CFrame
    function ToEulerAnglesXYZ(self): (number, number, number)
    function ToObjectSpace(self, other: CFrame): CFrame
    function ToWorldSpace(self, other: CFrame): CFrame
    UpVector: Vector3
    function VectorToObjectSpace(self, direction: Vector3): Vector3
    function VectorToWorldSpace(self, direction: Vector3): Vector3
    X: number
    Y: number
    Z: number
end

declare extern type Color3 with
    B: number
    G: number
    function Lerp(self, goal: Color3, alpha: number): Color3
    R: number
end

declare extern type UDim2 with
    XOffset: number
    XScale: number
    YOffset: number
    YScale: number
end

declare extern type UDim with
    Offset: number
    Scale: number
end

declare extern type Font with
    Bold: boolean
    Family: string
    Style: EnumItem
    Weight: EnumItem
end

declare extern type Ray with
    function ClosestPoint(self, point: Vector3): Vector3
    Direction: Vector3
    function Distance(self, point: Vector3): number
    Origin: Vector3
    Unit: Ray
end

declare extern type Vector2 with
    function Abs(self): Vector2
    function Angle(self, other: Vector2, isSigned: boolean?): number
    function Ceil(self): Vector2
    function Cross(self, other: Vector2): number
    function Dot(self, other: Vector2): number
    function Floor(self): Vector2
    function FuzzyEq(self, other: Vector2, epsilon: number?): boolean
    function Lerp(self, goal: Vector2, alpha: number): Vector2
    Magnitude: number
    function Max(self, other: Vector2): Vector2
    function Min(self, other: Vector2): Vector2
    function Sign(self): Vector2
    Unit: Vector2
    X: number
    Y: number
    magnitude: number
    x: number
    y: number
end

declare extern type NumberRange with
    Max: number
    Min: number
end

declare extern type NumberSequenceKeypoint with
    Envelope: number
    Time: number
    Value: number
end

declare extern type NumberSequence with
    Keypoints: {NumberSequenceKeypoint}
end

declare extern type ColorSequenceKeypoint with
    Time: number
    Value: Color3
end

declare extern type ColorSequence with
    Keypoints: {ColorSequenceKeypoint}
end

declare extern type Instance with
    AncestryChanged: BVScriptSignal -- fires (Instance, Instance?)
    AttributeChanged: BVScriptSignal -- fires (string)
    Changed: BVScriptSignal -- fires (string)
    ChildAdded: BVScriptSignal -- fires (Instance)
    ChildRemoved: BVScriptSignal -- fires (Instance)
    ClassName: string
    function Clone(self): Instance
    DescendantAdded: BVScriptSignal -- fires (Instance)
    function Destroy(self): ()
    Destroying: BVScriptSignal -- fires ()
    function FindFirstChild(self, name: string): Instance?
    function GetAttribute(self, name: string, field: string?): any
    function GetAttributeChangedSignal(self, attribute: string): BVScriptSignal
    function GetChildren(self): {Instance}
    function GetDescendants(self): {Instance}
    function GetFullName(self): string
    function GetPropertyChangedSignal(self, property: string): BVScriptSignal
    function IsA(self, className: string): boolean
    Name: string
    Parent: Instance?
    function SetAttribute(self, name: string, value: boolean | number | string | Vector3 | Color3 | CFrame | {[string]: any} | nil): ()
    function WaitForChild(self, name: string, timeout: number?): Instance?
end

declare extern type Attachment extends Instance with
    CFrame: CFrame
    Orientation: Vector3
    Position: Vector3
    Visible: boolean
    WorldCFrame: CFrame
    WorldPosition: Vector3
end

declare extern type BasePlayerGui extends Instance with
end

declare extern type BaseRemoteEvent extends Instance with
end

declare extern type BindableEvent extends Instance with
    Event: BVScriptSignal -- fires (...any)
    function Fire(self, ...: any): ()
end

declare extern type BindableFunction extends Instance with
    function Invoke(self, ...: any): ...any
    OnInvoke: ((...any) -> ...any)?
end

declare extern type Character extends Instance with
    AssemblyLinearVelocity: Vector3
    CFrame: CFrame
    Died: BVScriptSignal -- fires ()
    Health: number
    JumpPower: number
    MaxHealth: number
    function Move(self, direction: Vector3, relativeToCamera: boolean?): ()
    function MoveTo(self, target: Vector3): ()
    MoveToFinished: BVScriptSignal -- fires (boolean)
    Position: Vector3
    Rotation: Vector3
    function TakeDamage(self, amount: number): ()
    Touched: BVScriptSignal -- fires (Instance)
    WalkSpeed: number
end

declare extern type ClickDetector extends Instance with
    MaxActivationDistance: number
    MouseClick: BVScriptSignal -- fires (Instance)
end

declare extern type Constraint extends Instance with
    Attachment0: Attachment?
    Attachment1: Attachment?
    Enabled: boolean
end

declare extern type Folder extends Instance with
end

declare extern type GuiBase extends Instance with
end

declare extern type Light extends Instance with
    Brightness: number
    Color: Color3
    Enabled: boolean
    Range: number
    Shadows: boolean
end

declare extern type LuaSourceContainer extends Instance with
end

declare extern type PVInstance extends Instance with
    function GetPivot(self): CFrame
    function PivotTo(self, target: CFrame | Vector3): ()
end

declare extern type ParticleEmitter extends Instance with
    Acceleration: Vector3
    Brightness: number
    function Clear(self): ()
    Color: ColorSequence
    Drag: number
    EmissionDirection: EnumItem
    function Emit(self, particleCount: number?): ()
    Enabled: boolean
    function FastForward(self, seconds: number): ()
    FlipbookFramerate: NumberRange
    FlipbookLayout: EnumItem
    FlipbookMode: EnumItem
    FlipbookStartRandom: boolean
    Lifetime: NumberRange
    LightEmission: number
    LightInfluence: number
    LockedToPart: boolean
    Orientation: EnumItem
    Rate: number
    RotSpeed: NumberRange
    Rotation: NumberRange
    Shape: EnumItem
    ShapeInOut: EnumItem
    ShapePartial: number
    ShapeStyle: EnumItem
    Size: NumberSequence
    Speed: NumberRange
    SpreadAngle: Vector2
    Squash: NumberSequence
    Texture: string
    TimeScale: number
    Transparency: NumberSequence
    VelocityInheritance: number
    ZOffset: number
end

declare extern type Player extends Instance with
    Character: Instance?
    CharacterAdded: BVScriptSignal -- fires (Instance)
    function LoadCharacter(self): ()
    PlayerGui: PlayerGui?
    RespawnTime: number
    UserId: number
end

declare extern type PlayerPrefab extends Instance with
    AssemblyLinearVelocity: Vector3
    CFrame: CFrame
    Position: Vector3
    Rotation: Vector3
    function SpawnCharacter(self, position: Vector3?): Instance
    Touched: BVScriptSignal -- fires (Instance)
end

declare extern type RemoteFunction extends Instance with
    function InvokeClient(self, player: Instance, ...: any): ...any
    function InvokeServer(self, ...: any): ...any
    OnClientInvoke: ((...any) -> ...any)?
    OnServerInvoke: ((player: Instance, ...any) -> ...any)?
end

declare extern type Sound extends Instance with
    DidLoop: BVScriptSignal -- fires ()
    Ended: BVScriptSignal -- fires ()
    IsPaused: boolean
    IsPlaying: boolean
    Loaded: BVScriptSignal -- fires ()
    LoopRegion: NumberRange
    Looped: boolean
    function Pause(self): ()
    Paused: BVScriptSignal -- fires ()
    function Play(self): ()
    PlaybackRegion: NumberRange
    PlaybackRegionsEnabled: boolean
    PlaybackSpeed: number
    Played: BVScriptSignal -- fires ()
    function Resume(self): ()
    Resumed: BVScriptSignal -- fires ()
    RollOffMaxDistance: number
    RollOffMinDistance: number
    RollOffMode: EnumItem
    SoundGroup: SoundGroup?
    SoundId: string
    function Stop(self): ()
    Stopped: BVScriptSignal -- fires ()
    TimeLength: number
    TimePosition: number
    Volume: number
end

declare extern type SoundGroup extends Instance with
    Volume: number
end

declare extern type UIBase extends Instance with
end

declare extern type ValueBase extends Instance with
end

declare extern type WeldConstraint extends Instance with
    Enabled: boolean
    Part0: BasePart?
    Part1: BasePart?
end

declare extern type BasePart extends PVInstance with
    Anchored: boolean
    function ApplyImpulse(self, impulse: Vector3): ()
    AssemblyLinearVelocity: Vector3
    CFrame: CFrame
    CanCollide: boolean
    Color: Color3
    function GetNetworkOwner(self): Instance?
    function GetNetworkOwnershipAuto(self): boolean
    Material: EnumItem
    Position: Vector3
    Rotation: Vector3
    function SetNetworkOwner(self, player: Instance?): ()
    function SetNetworkOwnershipAuto(self): ()
    Size: Vector3
    Touched: BVScriptSignal -- fires (Instance)
    Transparency: number
end

declare extern type BaseScript extends LuaSourceContainer with
    Disabled: boolean
    Enabled: boolean
    RunContext: EnumItem
end

declare extern type BoolValue extends ValueBase with
    Value: boolean
end

declare extern type Camera extends PVInstance with
    CFrame: CFrame
    CameraSubject: Instance?
    CameraType: EnumItem
    DiagonalFieldOfView: number
    FieldOfView: number
    FieldOfViewMode: EnumItem
    Focus: CFrame
    function GetPartsObscuringTarget(self, castPoints: {Vector3}, ignoreList: {Instance}): {Instance}
    function GetRenderCFrame(self): CFrame
    HeadLocked: boolean
    HeadScale: number
    MaxAxisFieldOfView: number
    NearPlaneZ: number
    function ScreenPointToRay(self, x: number, y: number, depth: number?): Ray
    VRTiltAndRollEnabled: boolean
    function ViewportPointToRay(self, x: number, y: number, depth: number?): Ray
    ViewportSize: Vector3
    function WorldToScreenPoint(self, worldPoint: Vector3): (Vector3, boolean)
    function WorldToViewportPoint(self, worldPoint: Vector3): (Vector3, boolean)
    function ZoomToExtents(self, boundingBoxCFrame: CFrame, boundingBoxSize: Vector3): ()
end

declare extern type GuiBase2d extends GuiBase with
end

declare extern type HingeConstraint extends Constraint with
end

declare extern type IntValue extends ValueBase with
    Value: number
end

declare extern type Model extends PVInstance with
    function GetBoundingBox(self): (CFrame, Vector3)
    PrimaryPart: BasePart?
end

declare extern type ModuleScript extends LuaSourceContainer with
end

declare extern type NumberValue extends ValueBase with
    Value: number
end

declare extern type ObjectValue extends ValueBase with
    Value: Instance?
end

declare extern type PlayerGui extends BasePlayerGui with
end

declare extern type PointLight extends Light with
end

declare extern type RemoteEvent extends BaseRemoteEvent with
    function FireAllClients(self, ...: any): ()
    function FireClient(self, player: Instance, ...: any): ()
    function FireServer(self, ...: any): ()
    OnClientEvent: BVScriptSignal -- fires (...any)
    OnServerEvent: BVScriptSignal -- fires (Instance, ...any)
end

declare extern type RopeConstraint extends Constraint with
    Length: number
end

declare extern type SpotLight extends Light with
    Angle: number
end

declare extern type StringValue extends ValueBase with
    Value: string
end

declare extern type UIComponent extends UIBase with
end

declare extern type FormFactorPart extends BasePart with
end

declare extern type GuiObject extends GuiBase2d with
    AnchorPoint: Vector3
    BackgroundColor3: Color3
    BackgroundTransparency: number
    LayoutOrder: number
    Position: UDim2
    Size: UDim2
    Visible: boolean
end

declare extern type LayerCollector extends GuiBase2d with
end

declare extern type Script extends BaseScript with
end

declare extern type TriangleMeshPart extends BasePart with
    CollisionFidelity: EnumItem
end

declare extern type UICorner extends UIComponent with
    CornerRadius: UDim
end

declare extern type UIGradient extends UIComponent with
    Color: ColorSequence
    Rotation: number
    Transparency: NumberSequence
end

declare extern type UILayout extends UIComponent with
end

declare extern type UIPadding extends UIComponent with
    PaddingBottom: UDim
    PaddingLeft: UDim
    PaddingRight: UDim
    PaddingTop: UDim
end

declare extern type UIStroke extends UIComponent with
    ApplyStrokeMode: EnumItem
    Color: Color3
    Thickness: number
    Transparency: number
end

declare extern type WorldRoot extends Model with
end

declare extern type BillboardGui extends LayerCollector with
    AnchorPoint: Vector3
    Position: UDim2
    Size: UDim2
end

declare extern type Frame extends GuiObject with
end

declare extern type GuiButton extends GuiObject with
    Activated: BVScriptSignal -- fires ()
end

declare extern type GuiLabel extends GuiObject with
end

declare extern type LocalScript extends Script with
end

declare extern type MeshPart extends TriangleMeshPart with
    MeshId: string
    MeshSize: Vector3
end

declare extern type Part extends FormFactorPart with
    Shape: EnumItem
end

declare extern type ScreenGui extends LayerCollector with
    DisplayOrder: number
    Enabled: boolean
    IgnoreGuiInset: boolean
end

declare extern type TextBox extends GuiObject with
    function CaptureFocus(self): ()
    ClearTextOnFocus: boolean
    FocusLost: BVScriptSignal -- fires (boolean)
    Focused: BVScriptSignal -- fires ()
    FontFace: Font
    function IsFocused(self): boolean
    MultiLine: boolean
    function ReleaseFocus(self, submitted: boolean?): ()
    RichText: boolean
    Text: string
    TextColor3: Color3
    TextEditable: boolean
    TextScaled: boolean
    TextSize: number
    TextStrokeColor3: Color3
    TextStrokeTransparency: number
    TextXAlignment: EnumItem
    TextYAlignment: EnumItem
end

declare extern type UIGridStyleLayout extends UILayout with
end

declare extern type Workspace extends WorldRoot with
    CurrentCamera: Camera?
    Gravity: number
    function Raycast(self, origin: Vector3, direction: Vector3, raycastParams: {[string]: any}?): {[string]: any}?
end

declare extern type ImageLabel extends GuiLabel with
    Image: string
    ImageColor3: Color3
    ImageTransparency: number
end

declare extern type SpawnLocation extends Part with
end

declare extern type TextButton extends GuiButton with
    FontFace: Font
    RichText: boolean
    Text: string
    TextColor3: Color3
    TextScaled: boolean
    TextSize: number
    TextStrokeColor3: Color3
    TextStrokeTransparency: number
    TextXAlignment: EnumItem
    TextYAlignment: EnumItem
end

declare extern type TextLabel extends GuiLabel with
    FontFace: Font
    RichText: boolean
    Text: string
    TextColor3: Color3
    TextScaled: boolean
    TextSize: number
    TextStrokeColor3: Color3
    TextStrokeTransparency: number
    TextXAlignment: EnumItem
    TextYAlignment: EnumItem
end

declare extern type UIListLayout extends UIGridStyleLayout with
    FillDirection: EnumItem
    HorizontalAlignment: EnumItem
    Padding: UDim
    SortOrder: EnumItem
    VerticalAlignment: EnumItem
end

declare extern type Tween with
    function Cancel(self): ()
    ClassName: string
    Completed: BVScriptSignal -- fires (Enum.PlaybackState)
    function IsA(self, className: string): boolean
    Name: string
    function Pause(self): ()
    function Play(self): ()
end

declare extern type RunService with
    ClassName: string
    Heartbeat: BVScriptSignal -- fires (number)
    function IsA(self, className: string): boolean
    Name: string
end

declare extern type Players with
    CharacterAutoLoads: boolean
    ClassName: string
    function GetPlayers(self): {Player}
    function IsA(self, className: string): boolean
    LocalPlayer: Player?
    Name: string
    PlayerAdded: BVScriptSignal -- fires (Player)
    PlayerRemoving: BVScriptSignal -- fires (Player)
    RespawnTime: number
end

declare extern type UserInputService with
    ClassName: string
    function GetFocusedTextBox(self): TextBox?
    function GetMouseDelta(self): Vector3
    function GetMouseLocation(self): Vector3
    InputBegan: BVScriptSignal -- fires ({ KeyCode: Enum.KeyCode, UserInputType: Enum.UserInputType }, boolean)
    InputEnded: BVScriptSignal -- fires ({ KeyCode: Enum.KeyCode, UserInputType: Enum.UserInputType }, boolean)
    function IsA(self, className: string): boolean
    function IsKeyDown(self, key: EnumItem): boolean
    Name: string
end

declare extern type SoundService with
    ClassName: string
    function IsA(self, className: string): boolean
    Name: string
    function PlayLocalSound(self, sound: Instance): ()
end

declare extern type Lighting with
    Ambient: Color3
    Brightness: number
    ClassName: string
    ClockTime: number
    FogColor: Color3
    FogEnd: number
    FogStart: number
    GeographicLatitude: number
    function GetSunDirection(self): Vector3
    GlobalShadows: boolean
    function IsA(self, className: string): boolean
    Name: string
end

declare extern type Debris with
    function AddItem(self, item: Instance, lifetime: number?): ()
    ClassName: string
    function IsA(self, className: string): boolean
    Name: string
end

declare extern type TweenService with
    ClassName: string
    function Create(self, instance: Instance, tweenInfo: TweenInfo?, properties: {[string]: any}): Tween
    function GetValue(self, alpha: number, easingStyle: EnumItem, easingDirection: EnumItem): number
    function IsA(self, className: string): boolean
    Name: string
end

declare extern type CollectionService with
    function AddTag(self, instance: Instance, tag: string): ()
    ClassName: string
    function GetInstanceAddedSignal(self, tag: string): BVScriptSignal
    function GetInstanceRemovedSignal(self, tag: string): BVScriptSignal
    function GetTagged(self, tag: string): {Instance}
    function GetTags(self, instance: Instance): {string}
    function HasTag(self, instance: Instance, tag: string): boolean
    function IsA(self, className: string): boolean
    Name: string
    function RemoveTag(self, instance: Instance, tag: string): ()
end

declare extern type DataModel with
    GetService: ((self: DataModel, service: "Workspace") -> Workspace) & ((self: DataModel, service: "RunService") -> RunService) & ((self: DataModel, service: "Players") -> Players) & ((self: DataModel, service: "UserInputService") -> UserInputService) & ((self: DataModel, service: "SoundService") -> SoundService) & ((self: DataModel, service: "Lighting") -> Lighting) & ((self: DataModel, service: "Debris") -> Debris) & ((self: DataModel, service: "TweenService") -> TweenService) & ((self: DataModel, service: "CollectionService") -> CollectionService) & ((self: DataModel, service: string) -> Instance)
    ClassName: string
    function IsA(self, className: string): boolean
    Name: string
end

declare CFrame: {
    Angles: (rx: number, ry: number, rz: number) -> CFrame,
    fromAxisAngle: (axis: Vector3, angle: number) -> CFrame,
    fromEulerAnglesXYZ: (rx: number, ry: number, rz: number) -> CFrame,
    identity: CFrame,
    lookAt: (position: Vector3, target: Vector3, up: Vector3?) -> CFrame,
    new: (() -> CFrame) & ((position: Vector3) -> CFrame) & ((position: Vector3, lookAt: Vector3) -> CFrame) & ((x: number, y: number, z: number) -> CFrame),
}

declare Color3: {
    fromHSV: (h: number, s: number, v: number) -> Color3,
    fromRGB: (r: number, g: number, b: number) -> Color3,
    new: (r: number?, g: number?, b: number?) -> Color3,
}

declare ColorSequence: {
    new: ((color: Color3) -> ColorSequence) & ((color0: Color3, color1: Color3) -> ColorSequence) & ((keypoints: {ColorSequenceKeypoint}) -> ColorSequence),
}

declare ColorSequenceKeypoint: {
    new: (time: number, color: Color3) -> ColorSequenceKeypoint,
}

declare Font: {
    new: (family: string, weight: EnumItem?, style: EnumItem?) -> Font,
}

declare Instance: {
    new: ((className: "Attachment") -> Attachment) & ((className: "BillboardGui") -> BillboardGui) & ((className: "BindableEvent") -> BindableEvent) & ((className: "BindableFunction") -> BindableFunction) & ((className: "BoolValue") -> BoolValue) & ((className: "Camera") -> Camera) & ((className: "ClickDetector") -> ClickDetector) & ((className: "Folder") -> Folder) & ((className: "Frame") -> Frame) & ((className: "HingeConstraint") -> HingeConstraint) & ((className: "ImageLabel") -> ImageLabel) & ((className: "IntValue") -> IntValue) & ((className: "MeshPart") -> MeshPart) & ((className: "Model") -> Model) & ((className: "NumberValue") -> NumberValue) & ((className: "ObjectValue") -> ObjectValue) & ((className: "Part") -> Part) & ((className: "ParticleEmitter") -> ParticleEmitter) & ((className: "PointLight") -> PointLight) & ((className: "RemoteEvent") -> RemoteEvent) & ((className: "RemoteFunction") -> RemoteFunction) & ((className: "RopeConstraint") -> RopeConstraint) & ((className: "ScreenGui") -> ScreenGui) & ((className: "Sound") -> Sound) & ((className: "SoundGroup") -> SoundGroup) & ((className: "SpotLight") -> SpotLight) & ((className: "StringValue") -> StringValue) & ((className: "TextBox") -> TextBox) & ((className: "TextButton") -> TextButton) & ((className: "TextLabel") -> TextLabel) & ((className: "UICorner") -> UICorner) & ((className: "UIGradient") -> UIGradient) & ((className: "UIListLayout") -> UIListLayout) & ((className: "UIPadding") -> UIPadding) & ((className: "UIStroke") -> UIStroke) & ((className: "WeldConstraint") -> WeldConstraint) & ((className: string) -> Instance),
}

declare NumberRange: {
    new: ((value: number) -> NumberRange) & ((min: number, max: number) -> NumberRange),
}

declare NumberSequence: {
    new: ((value: number) -> NumberSequence) & ((value0: number, value1: number) -> NumberSequence) & ((keypoints: {NumberSequenceKeypoint}) -> NumberSequence),
}

declare NumberSequenceKeypoint: {
    new: (time: number, value: number, envelope: number?) -> NumberSequenceKeypoint,
}

declare Ray: {
    new: (origin: Vector3, direction: Vector3) -> Ray,
}

declare TweenInfo: {
    new: (time: number?, easingStyle: EnumItem?, easingDirection: EnumItem?, repeatCount: number?, reverses: boolean?, delayTime: number?) -> TweenInfo,
}

declare UDim: {
    new: (scale: number?, offset: number?) -> UDim,
}

declare UDim2: {
    fromOffset: (x: number, y: number) -> UDim2,
    fromScale: (x: number, y: number) -> UDim2,
    new: (xScale: number, xOffset: number, yScale: number, yOffset: number) -> UDim2,
}

declare Vector2: {
    new: (x: number?, y: number?) -> Vector2,
    one: Vector2,
    xAxis: Vector2,
    yAxis: Vector2,
    zero: Vector2,
}

declare Vector3: {
    new: (x: number?, y: number?, z: number?) -> Vector3,
    one: Vector3,
    xAxis: Vector3,
    yAxis: Vector3,
    zAxis: Vector3,
    zero: Vector3,
}

declare Enum: {
    ApplyStrokeMode: { Border: EnumItem, Contextual: EnumItem },
    CameraType: { Attach: EnumItem, Custom: EnumItem, Fixed: EnumItem, Follow: EnumItem, Orbital: EnumItem, Scriptable: EnumItem, Track: EnumItem, Watch: EnumItem },
    CollisionFidelity: { Box: EnumItem, Default: EnumItem, Hull: EnumItem, PreciseConvexDecomposition: EnumItem },
    EasingDirection: { In: EnumItem, InOut: EnumItem, Out: EnumItem },
    EasingStyle: { Back: EnumItem, Bounce: EnumItem, Circular: EnumItem, Cubic: EnumItem, Elastic: EnumItem, Exponential: EnumItem, Linear: EnumItem, Quad: EnumItem, Quart: EnumItem, Quint: EnumItem, Sine: EnumItem },
    FieldOfViewMode: { Diagonal: EnumItem, MaxAxis: EnumItem, Vertical: EnumItem },
    FillDirection: { Horizontal: EnumItem, Vertical: EnumItem },
    FontStyle: { Italic: EnumItem, Normal: EnumItem },
    FontWeight: { Bold: EnumItem, ExtraBold: EnumItem, ExtraLight: EnumItem, Heavy: EnumItem, Light: EnumItem, Medium: EnumItem, Regular: EnumItem, SemiBold: EnumItem, Thin: EnumItem },
    HorizontalAlignment: { Center: EnumItem, Left: EnumItem, Right: EnumItem },
    KeyCode: { A: EnumItem, B: EnumItem, BackSlash: EnumItem, Backquote: EnumItem, Backspace: EnumItem, C: EnumItem, CapsLock: EnumItem, Comma: EnumItem, D: EnumItem, Delete: EnumItem, Down: EnumItem, E: EnumItem, Eight: EnumItem, End: EnumItem, Equals: EnumItem, Escape: EnumItem, F: EnumItem, F1: EnumItem, F10: EnumItem, F11: EnumItem, F12: EnumItem, F2: EnumItem, F3: EnumItem, F4: EnumItem, F5: EnumItem, F6: EnumItem, F7: EnumItem, F8: EnumItem, F9: EnumItem, Five: EnumItem, Four: EnumItem, G: EnumItem, H: EnumItem, Home: EnumItem, I: EnumItem, Insert: EnumItem, J: EnumItem, K: EnumItem, L: EnumItem, Left: EnumItem, LeftAlt: EnumItem, LeftBracket: EnumItem, LeftControl: EnumItem, LeftShift: EnumItem, M: EnumItem, Minus: EnumItem, N: EnumItem, Nine: EnumItem, O: EnumItem, One: EnumItem, P: EnumItem, PageDown: EnumItem, PageUp: EnumItem, Period: EnumItem, Q: EnumItem, Quote: EnumItem, R: EnumItem, Return: EnumItem, Right: EnumItem, RightAlt: EnumItem, RightBracket: EnumItem, RightControl: EnumItem, RightShift: EnumItem, S: EnumItem, Semicolon: EnumItem, Seven: EnumItem, Six: EnumItem, Slash: EnumItem, Space: EnumItem, T: EnumItem, Tab: EnumItem, Three: EnumItem, Two: EnumItem, U: EnumItem, Unknown: EnumItem, Up: EnumItem, V: EnumItem, W: EnumItem, X: EnumItem, Y: EnumItem, Z: EnumItem, Zero: EnumItem },
    Material: { Brick: EnumItem, Concrete: EnumItem, Glass: EnumItem, Grass: EnumItem, Metal: EnumItem, Neon: EnumItem, Plastic: EnumItem, Slate: EnumItem, SmoothPlastic: EnumItem, Wood: EnumItem },
    NormalId: { Back: EnumItem, Bottom: EnumItem, Front: EnumItem, Left: EnumItem, Right: EnumItem, Top: EnumItem },
    PartType: { Ball: EnumItem, Block: EnumItem, CornerWedge: EnumItem, Cylinder: EnumItem, Wedge: EnumItem },
    ParticleEmitterShape: { Box: EnumItem, Cylinder: EnumItem, Disc: EnumItem, Sphere: EnumItem },
    ParticleEmitterShapeInOut: { InAndOut: EnumItem, Inward: EnumItem, Outward: EnumItem },
    ParticleEmitterShapeStyle: { Surface: EnumItem, Volume: EnumItem },
    ParticleFlipbookLayout: { Custom: EnumItem, Grid2x2: EnumItem, Grid4x4: EnumItem, Grid8x8: EnumItem, None: EnumItem },
    ParticleFlipbookMode: { Loop: EnumItem, OneShot: EnumItem, PingPong: EnumItem, Random: EnumItem },
    ParticleOrientation: { FacingCamera: EnumItem, FacingCameraWorldUp: EnumItem, VelocityParallel: EnumItem, VelocityPerpendicular: EnumItem },
    PlaybackState: { Begin: EnumItem, Cancelled: EnumItem, Completed: EnumItem, Delayed: EnumItem, Paused: EnumItem, Playing: EnumItem },
    RaycastFilterType: { Exclude: EnumItem, Include: EnumItem },
    RollOffMode: { Inverse: EnumItem, InverseTapered: EnumItem, Linear: EnumItem, LinearSquare: EnumItem },
    RunContext: { Client: EnumItem, Legacy: EnumItem, Server: EnumItem },
    SortOrder: { Custom: EnumItem, LayoutOrder: EnumItem, Name: EnumItem },
    TextXAlignment: { Center: EnumItem, Left: EnumItem, Right: EnumItem },
    TextYAlignment: { Bottom: EnumItem, Center: EnumItem, Top: EnumItem },
    UserInputType: { Keyboard: EnumItem, MouseButton1: EnumItem, MouseButton2: EnumItem, MouseButton3: EnumItem },
    VerticalAlignment: { Bottom: EnumItem, Center: EnumItem, Top: EnumItem },
}

declare function warn(...: any): ()

declare workspace: Workspace
declare script: Instance
declare game: DataModel
