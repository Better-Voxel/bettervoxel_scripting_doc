-- bettervoxel.d.luau — the BetterVoxel scripting API, generated from the live
-- engine's pinned model. Do not edit: regenerate with
--   cargo test -p bv_engine_core --features docgen --test api_surface
-- The syntax is Luau's current definition-file grammar (extern types),
-- validated in CI with luau-lsp analyze against a smoke script.
-- Vector3 is declared as the reference's class, its surface the one the
-- engine serves on Luau's native vector. The VM has ONE type for both
-- dialects (typeof says "vector"); the checker has two: a
-- vector.create value is its builtin vector and does not mix with an
-- engine API's Vector3 — a recorded divergence.
-- Signals are declared without payload generics; each member's fired
-- arguments ride its trailing comment.

declare extern type Vector3 with
    function Abs(self): Vector3
    function Angle(self, other: Vector3, axis: Vector3?): number
    function Ceil(self): Vector3
    function Cross(self, other: Vector3): Vector3
    function Dot(self, other: Vector3): number
    function Floor(self): Vector3
    function FuzzyEq(self, other: Vector3, epsilon: number?): boolean
    function Lerp(self, goal: Vector3, alpha: number): Vector3
    Magnitude: number
    function Max(self, ...: Vector3): Vector3
    function Min(self, ...: Vector3): Vector3
    function Sign(self): Vector3
    Unit: Vector3
    X: number
    Y: number
    Z: number
    @deprecated
    function lerp(self, goal: Vector3, alpha: number): Vector3
    magnitude: number -- deprecated
    unit: Vector3 -- deprecated
    x: number
    y: number
    z: number
    function __add(self, other: Vector3): Vector3
    function __sub(self, other: Vector3): Vector3
    function __mul(self, other: Vector3): Vector3
    function __mul(self, other: number): Vector3
    function __div(self, other: Vector3): Vector3
    function __div(self, other: number): Vector3
    function __idiv(self, other: Vector3): Vector3
    function __idiv(self, other: number): Vector3
    function __unm(self): Vector3
end

declare extern type BVScriptConnection with
    Connected: boolean
    function Disconnect(self): ()
    connected: boolean -- deprecated
    @deprecated
    function disconnect(self): ()
end

declare extern type BVScriptSignal with
    function Connect(self, callback: (...any) -> ()): BVScriptConnection
    function Once(self, callback: (...any) -> ()): BVScriptConnection
    function Wait(self): ...any
    @deprecated
    function connect(self, callback: (...any) -> ()): BVScriptConnection
    @deprecated
    function wait(self): ...any
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

declare extern type Random with
    function Clone(self): Random
    function NextInteger(self, min: number, max: number): number
    function NextNumber(self, min: number?, max: number?): number
    function NextUnitVector(self): Vector3
    function Shuffle(self, t: {any}): ()
end

declare extern type RaycastParams with
    function AddToFilter(self, instances: Instance | {Instance}): ()
    BruteForceAllSlow: boolean
    CollisionGroup: string
    ExcludeInstances: {Instance}?
    FilterDescendantsInstances: {Instance}
    FilterType: EnumItem
    IgnoreWater: boolean
    IncludeInstances: {Instance}?
    RespectCanCollide: boolean
    ServerTime: number?
end

declare extern type CFrame with
    function AngleBetween(self, other: CFrame): number
    function FuzzyEq(self, other: CFrame, eps: number?): boolean
    function GetComponents(self): (number, number, number, number, number, number, number, number, number, number, number, number)
    function Inverse(self): CFrame
    function Lerp(self, goal: CFrame, alpha: number): CFrame
    LookVector: Vector3
    function Orthonormalize(self): CFrame
    function PointToObjectSpace(self, ...: Vector3): ...Vector3
    function PointToWorldSpace(self, ...: Vector3): ...Vector3
    Position: Vector3
    RightVector: Vector3
    Rotation: CFrame
    function ToAxisAngle(self): (Vector3, number)
    function ToEulerAngles(self, order: EnumItem?): (number, number, number)
    function ToEulerAnglesXYZ(self): (number, number, number)
    function ToEulerAnglesYXZ(self): (number, number, number)
    function ToObjectSpace(self, ...: CFrame): ...CFrame
    function ToOrientation(self): (number, number, number)
    function ToWorldSpace(self, ...: CFrame): ...CFrame
    UpVector: Vector3
    function VectorToObjectSpace(self, ...: Vector3): ...Vector3
    function VectorToWorldSpace(self, ...: Vector3): ...Vector3
    X: number
    XVector: Vector3
    Y: number
    YVector: Vector3
    Z: number
    ZVector: Vector3
    @deprecated
    function components(self): (number, number, number, number, number, number, number, number, number, number, number, number)
    @deprecated
    function inverse(self): CFrame
    @deprecated
    function lerp(self, goal: CFrame, alpha: number): CFrame
    lookVector: Vector3 -- deprecated
    p: Vector3 -- deprecated
    @deprecated
    function pointToObjectSpace(self, ...: Vector3): ...Vector3
    @deprecated
    function pointToWorldSpace(self, ...: Vector3): ...Vector3
    rightVector: Vector3 -- deprecated
    @deprecated
    function toAxisAngle(self): (Vector3, number)
    @deprecated
    function toEulerAnglesXYZ(self): (number, number, number)
    @deprecated
    function toEulerAnglesYXZ(self): (number, number, number)
    @deprecated
    function toObjectSpace(self, ...: CFrame): ...CFrame
    @deprecated
    function toOrientation(self): (number, number, number)
    @deprecated
    function toWorldSpace(self, ...: CFrame): ...CFrame
    upVector: Vector3 -- deprecated
    @deprecated
    function vectorToObjectSpace(self, ...: Vector3): ...Vector3
    @deprecated
    function vectorToWorldSpace(self, ...: Vector3): ...Vector3
    x: number -- deprecated
    y: number -- deprecated
    z: number -- deprecated
    function __mul(self, other: CFrame): CFrame
    function __mul(self, other: Vector3): Vector3
    function __add(self, other: Vector3): CFrame
    function __sub(self, other: Vector3): CFrame
end

declare extern type Color3 with
    B: number
    G: number
    function Lerp(self, goal: Color3, alpha: number): Color3
    R: number
    function ToHSV(self): (number, number, number)
    function ToHex(self): string
    @deprecated
    function lerp(self, goal: Color3, alpha: number): Color3
end

declare extern type BrickColor with
    Color: Color3
    Name: string
    Number: number
    b: number
    g: number
    r: number
end

declare extern type UDim2 with
    Height: UDim
    function Lerp(self, goal: UDim2, alpha: number): UDim2
    Width: UDim
    X: UDim
    Y: UDim
    @deprecated
    function lerp(self, goal: UDim2, alpha: number): UDim2
    function __add(self, other: UDim2): UDim2
    function __sub(self, other: UDim2): UDim2
    function __unm(self): UDim2
end

declare extern type UDim with
    Offset: number
    Scale: number
    function __add(self, other: UDim): UDim
    function __sub(self, other: UDim): UDim
    function __unm(self): UDim
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
    @deprecated
    function lerp(self, goal: Vector2, alpha: number): Vector2
    magnitude: number -- deprecated
    unit: Vector2 -- deprecated
    x: number -- deprecated
    y: number -- deprecated
    function __add(self, other: Vector2): Vector2
    function __sub(self, other: Vector2): Vector2
    function __mul(self, other: Vector2): Vector2
    function __mul(self, other: number): Vector2
    function __div(self, other: Vector2): Vector2
    function __div(self, other: number): Vector2
    function __idiv(self, other: Vector2): Vector2
    function __idiv(self, other: number): Vector2
    function __unm(self): Vector2
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
    Archivable: boolean
    AttributeChanged: BVScriptSignal -- fires (string)
    Changed: BVScriptSignal -- fires (string)
    ChildAdded: BVScriptSignal -- fires (Instance)
    ChildRemoved: BVScriptSignal -- fires (Instance)
    ClassName: string
    function ClearAllChildren(self): ()
    function Clone(self): Instance
    DescendantAdded: BVScriptSignal -- fires (Instance)
    function Destroy(self): ()
    Destroying: BVScriptSignal -- fires ()
    function FindFirstAncestor(self, name: string): Instance?
    function FindFirstAncestorOfClass(self, className: string): Instance?
    function FindFirstAncestorWhichIsA(self, className: string): Instance?
    function FindFirstChild(self, name: string): Instance?
    function FindFirstChildOfClass(self, className: string): Instance?
    function FindFirstChildWhichIsA(self, className: string, recursive: boolean?): Instance?
    function GetAttribute(self, name: string, field: string?): any
    function GetAttributeChangedSignal(self, attribute: string): BVScriptSignal
    function GetAttributes(self): {[string]: any}
    function GetChildren(self): {Instance}
    function GetDescendants(self): {Instance}
    function GetFullName(self): string
    function GetPropertyChangedSignal(self, property: string): BVScriptSignal
    function IsA(self, className: string): boolean
    function IsAncestorOf(self, descendant: Instance?): boolean
    function IsDescendantOf(self, ancestor: Instance?): boolean
    Name: string
    Parent: Instance?
    PredictionMode: EnumItem
    @deprecated
    function Remove(self): ()
    function SetAttribute(self, name: string, value: boolean | number | string | Vector3 | Color3 | CFrame | {[string]: any} | nil): ()
    function WaitForChild(self, name: string, timeout: number?): Instance?
    changed: BVScriptSignal -- deprecated; fires (string)
    @deprecated
    function clone(self): Instance
    @deprecated
    function destroy(self): ()
    @deprecated
    function findFirstChild(self, name: string): Instance?
    @deprecated
    function remove(self): ()
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
    AssemblyAngularVelocity: Vector3
    AssemblyCenterOfMass: Vector3
    AssemblyLinearVelocity: Vector3
    AssemblyMass: number
    CFrame: CFrame
    CenterOfMass: Vector3
    Mass: number
    Position: Vector3
    RotVelocity: Vector3 -- deprecated
    Rotation: Vector3
    Touched: BVScriptSignal -- fires (Instance)
    Velocity: Vector3 -- deprecated
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

declare extern type DataStoreGetOptions extends Instance with
    UseCache: boolean
end

declare extern type DataStoreIncrementOptions extends Instance with
    function GetMetadata(self): {[string]: any}
    function SetMetadata(self, attributes: {[string]: any}): ()
end

declare extern type DataStoreOptions extends Instance with
    AllScopes: boolean
    function SetExperimentalFeatures(self, experimentalFeatures: {[string]: boolean}): ()
end

declare extern type DataStoreSetOptions extends Instance with
    function GetMetadata(self): {[string]: any}
    function SetMetadata(self, attributes: {[string]: any}): ()
end

declare extern type Folder extends Instance with
end

declare extern type GuiBase extends Instance with
end

declare extern type Humanoid extends Instance with
    Died: BVScriptSignal -- fires ()
    DisplayName: string
    FreeFalling: BVScriptSignal -- fires (boolean)
    function GetMoveVelocity(self): Vector3
    function GetState(self): EnumItem
    function GetStateEnabled(self, state: EnumItem): boolean
    Health: number
    HealthChanged: BVScriptSignal -- fires (number)
    Jump: boolean
    JumpPower: number
    Jumping: BVScriptSignal -- fires (boolean)
    MaxHealth: number
    function Move(self, direction: Vector3, relativeToCamera: boolean?): ()
    MoveDirection: Vector3
    function MoveTo(self, target: Vector3, part: Instance?): ()
    MoveToFinished: BVScriptSignal -- fires (boolean)
    PlatformStand: boolean
    RootPart: Instance?
    Running: BVScriptSignal -- fires (number)
    SeatPart: Instance?
    Seated: BVScriptSignal -- fires (boolean, Instance?)
    function SetStateEnabled(self, state: EnumItem, enabled: boolean): ()
    Sit: boolean
    StateChanged: BVScriptSignal -- fires (Enum.HumanoidStateType, Enum.HumanoidStateType)
    function TakeDamage(self, amount: number): ()
    Touched: BVScriptSignal -- fires (Instance, Instance)
    WalkSpeed: number
    WalkToPart: Instance?
    WalkToPoint: Vector3
end

declare extern type InputAction extends Instance with
    Enabled: boolean
    function Fire(self, state: any): ()
    function GetState(self): any
    Pressed: BVScriptSignal -- fires (boolean)
    Released: BVScriptSignal -- fires (boolean)
    StateChanged: BVScriptSignal -- fires (any)
    Type: EnumItem
end

declare extern type InputBinding extends Instance with
    Backward: EnumItem
    ClampMagnitudeToOne: boolean
    Down: EnumItem
    Forward: EnumItem
    KeyCode: EnumItem
    Left: EnumItem
    PrimaryModifier: EnumItem
    Right: EnumItem
    Scale: number
    SecondaryModifier: EnumItem
    Up: EnumItem
    Vector2Scale: Vector2
    Vector3Scale: Vector3
end

declare extern type InputContext extends Instance with
    Enabled: boolean
    Priority: number
    Sink: boolean
end

declare extern type JointInstance extends Instance with
    Active: boolean
    C0: CFrame
    C1: CFrame
    Enabled: boolean
    Part0: BasePart?
    Part1: BasePart?
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
    CharacterRemoving: BVScriptSignal -- fires (Instance)
    DisplayName: string
    function GetCameraState(self): {CFrame: CFrame, FieldOfView: number, ViewportSize: Vector2}
    function GetMouse(self): PlayerMouse
    function GetNetworkPing(self): number
    function Kick(self, message: string?): ()
    @deprecated
    function LoadCharacter(self): ()
    function LoadCharacterAsync(self): ()
    PlayerGui: PlayerGui?
    RespawnTime: number
    UserId: number
end

declare extern type PlayerPrefab extends Instance with
    AssemblyAngularVelocity: Vector3
    AssemblyCenterOfMass: Vector3
    AssemblyLinearVelocity: Vector3
    AssemblyMass: number
    CFrame: CFrame
    CenterOfMass: Vector3
    Mass: number
    Position: Vector3
    RotVelocity: Vector3 -- deprecated
    Rotation: Vector3
    function SpawnCharacter(self, position: Vector3?): Instance
    Touched: BVScriptSignal -- fires (Instance)
    Velocity: Vector3 -- deprecated
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

declare extern type AlignOrientation extends Constraint with
    Active: boolean
    AlignType: EnumItem
    CFrame: CFrame
    LookAtPosition: Vector3
    MaxAngularVelocity: number
    MaxTorque: number
    Mode: EnumItem
    PrimaryAxis: Vector3
    PrimaryAxisOnly: boolean -- deprecated
    ReactionTorqueEnabled: boolean
    Responsiveness: number
    RigidityEnabled: boolean
    SecondaryAxis: Vector3
    Visible: boolean
end

declare extern type AlignPosition extends Constraint with
    Active: boolean
    ApplyAtCenterOfMass: boolean
    ForceLimitMode: EnumItem
    ForceRelativeTo: EnumItem
    MaxAxesForce: Vector3
    MaxForce: number
    MaxVelocity: number
    Mode: EnumItem
    Position: Vector3
    ReactionForceEnabled: boolean
    Responsiveness: number
    RigidityEnabled: boolean
    Visible: boolean
end

declare extern type AngularVelocity extends Constraint with
    Active: boolean
    AngularVelocity: Vector3
    MaxTorque: number
    ReactionTorqueEnabled: boolean
    RelativeTo: EnumItem
    Visible: boolean
end

declare extern type BallSocketConstraint extends Constraint with
    Active: boolean
    LimitsEnabled: boolean
    MaxFrictionTorque: number
    Radius: number
    Restitution: number
    TwistLimitsEnabled: boolean
    TwistLowerAngle: number
    TwistUpperAngle: number
    UpperAngle: number
end

declare extern type BasePart extends PVInstance with
    Anchored: boolean
    function ApplyAngularImpulse(self, impulse: Vector3): ()
    function ApplyImpulse(self, impulse: Vector3): ()
    function ApplyImpulseAtPosition(self, impulse: Vector3, position: Vector3): ()
    AssemblyAngularVelocity: Vector3
    AssemblyCenterOfMass: Vector3
    AssemblyLinearVelocity: Vector3
    AssemblyMass: number
    BrickColor: BrickColor
    CFrame: CFrame
    CanCollide: boolean
    CastShadow: boolean
    CenterOfMass: Vector3
    Color: Color3
    function GetMass(self): number
    function GetNetworkOwner(self): Instance?
    function GetNetworkOwnershipAuto(self): boolean
    function GetRenderCFrame(self): CFrame
    Locked: boolean
    Mass: number
    Material: EnumItem
    Position: Vector3
    RotVelocity: Vector3 -- deprecated
    Rotation: Vector3
    function SetNetworkOwner(self, player: Instance?): ()
    function SetNetworkOwnershipAuto(self): ()
    Size: Vector3
    Touched: BVScriptSignal -- fires (Instance)
    Transparency: number
    Velocity: Vector3 -- deprecated
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
    ViewportSize: Vector2
    function WorldToScreenPoint(self, worldPoint: Vector3): (Vector3, boolean)
    function WorldToViewportPoint(self, worldPoint: Vector3): (Vector3, boolean)
    function ZoomToExtents(self, boundingBoxCFrame: CFrame, boundingBoxSize: Vector3): ()
end

declare extern type GuiBase2d extends GuiBase with
end

declare extern type HingeConstraint extends Constraint with
    ActuatorType: EnumItem
    AngularResponsiveness: number
    AngularSpeed: number
    AngularVelocity: number
    CurrentAngle: number
    LimitsEnabled: boolean
    LowerAngle: number
    MotorMaxAcceleration: number
    MotorMaxTorque: number
    Radius: number
    Restitution: number
    ServoMaxTorque: number
    SoftlockServoUponReachingTarget: boolean -- deprecated
    TargetAngle: number
    UpperAngle: number
end

declare extern type IntValue extends ValueBase with
    Value: number
end

declare extern type LinearVelocity extends Constraint with
    Active: boolean
    ForceLimitMode: EnumItem
    ForceLimitsEnabled: boolean
    LineDirection: Vector3
    LineVelocity: number
    MaxAxesForce: Vector3
    MaxForce: number
    MaxPlanarAxesForce: Vector2
    PlaneVelocity: Vector2
    PrimaryTangentAxis: Vector3
    ReactionForceEnabled: boolean
    RelativeTo: EnumItem
    SecondaryTangentAxis: Vector3
    VectorVelocity: Vector3
    VelocityConstraintMode: EnumItem
    Visible: boolean
end

declare extern type Model extends PVInstance with
    function GetBoundingBox(self): (CFrame, Vector3)
    @deprecated
    function GetPrimaryPartCFrame(self): CFrame
    PrimaryPart: BasePart?
    @deprecated
    function SetPrimaryPartCFrame(self, cframe: CFrame): ()
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

declare extern type RodConstraint extends Constraint with
    Active: boolean
    CurrentDistance: number
    Length: number
    LimitAngle0: number
    LimitAngle1: number
    LimitsEnabled: boolean
    Thickness: number
end

declare extern type RopeConstraint extends Constraint with
    Length: number
end

declare extern type SpotLight extends Light with
    Angle: number
end

declare extern type SpringConstraint extends Constraint with
    Active: boolean
    Coils: number
    CurrentLength: number
    Damping: number
    FreeLength: number
    LimitsEnabled: boolean
    MaxForce: number
    MaxLength: number
    MinLength: number
    Radius: number
    Stiffness: number
    Thickness: number
end

declare extern type StringValue extends ValueBase with
    Value: string
end

declare extern type Torque extends Constraint with
    Active: boolean
    RelativeTo: EnumItem
    Torque: Vector3
    Visible: boolean
end

declare extern type UIComponent extends UIBase with
end

declare extern type VectorForce extends Constraint with
    Active: boolean
    ApplyAtCenterOfMass: boolean
    Force: Vector3
    RelativeTo: EnumItem
    Visible: boolean
end

declare extern type Weld extends JointInstance with
end

declare extern type FormFactorPart extends BasePart with
end

declare extern type GuiObject extends GuiBase2d with
    AnchorPoint: Vector2
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
    AnchorPoint: Vector2
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
    Font: EnumItem
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
    AuthorityMode: EnumItem
    CurrentCamera: Camera?
    function GetRenderedServerTime(self, instance: Instance?): number
    function GetServerTimeNow(self): number
    Gravity: number
    function Raycast(self, origin: Vector3, direction: Vector3, raycastParams: (RaycastParams | {[string]: any})?): {[string]: any}?
end

declare extern type ImageLabel extends GuiLabel with
    Image: string
    ImageColor3: Color3
    ImageTransparency: number
end

declare extern type SpawnLocation extends Part with
end

declare extern type TextButton extends GuiButton with
    Font: EnumItem
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
    Font: EnumItem
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

declare extern type ReplicatedStorage extends Instance with
end

declare extern type ServerStorage extends Instance with
end

declare extern type ServerScriptService extends Instance with
end

declare extern type StarterPlayerScripts extends Instance with
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

declare extern type PlayerMouse with
    Button1Down: BVScriptSignal -- fires ()
    Button1Up: BVScriptSignal -- fires ()
    Button2Down: BVScriptSignal -- fires ()
    Button2Up: BVScriptSignal -- fires ()
    ClassName: string
    function Destroy(self): ()
    Hit: CFrame
    Icon: string
    Idle: BVScriptSignal -- fires ()
    function IsA(self, className: string): boolean
    KeyDown: BVScriptSignal -- deprecated; fires ()
    KeyUp: BVScriptSignal -- deprecated; fires ()
    Move: BVScriptSignal -- fires ()
    Name: string
    Origin: CFrame
    Target: BasePart?
    TargetFilter: Instance?
    TargetSurface: EnumItem
    UnitRay: Ray
    ViewSizeX: number
    ViewSizeY: number
    WheelBackward: BVScriptSignal -- fires ()
    WheelForward: BVScriptSignal -- fires ()
    X: number
    Y: number
end

declare extern type DataStoreKeyInfo with
    ClassName: string
    CreatedTime: number
    function GetFullName(self): string
    function GetMetadata(self): {[string]: any}
    function GetUserIds(self): {number}
    Name: string
    Parent: Instance?
    UpdatedTime: number
    Version: string
end

declare extern type DataStoreObjectVersionInfo with
    ClassName: string
    CreatedTime: number
    IsDeleted: boolean
    Version: string
end

declare extern type DataStoreKey with
    ClassName: string
    KeyName: string
end

declare extern type DataStoreInfo with
    ClassName: string
    CreatedTime: number
    DataStoreName: string
    UpdatedTime: number
end

declare extern type DataStoreVersionPages with
    function AdvanceToNextPageAsync(self): ()
    ClassName: string
    function GetCurrentPage(self): {DataStoreObjectVersionInfo}
    function IsA(self, className: string): boolean
    IsFinished: boolean
end

declare extern type DataStoreKeyPages with
    function AdvanceToNextPageAsync(self): ()
    ClassName: string
    Cursor: string
    function GetCurrentPage(self): {DataStoreKey}
    function IsA(self, className: string): boolean
    IsFinished: boolean
end

declare extern type DataStoreListingPages with
    function AdvanceToNextPageAsync(self): ()
    ClassName: string
    Cursor: string
    function GetCurrentPage(self): {DataStoreInfo}
    function IsA(self, className: string): boolean
    IsFinished: boolean
end

declare extern type DataStorePages with
    function AdvanceToNextPageAsync(self): ()
    ClassName: string
    function GetCurrentPage(self): {{key: string, value: number}}
    function IsA(self, className: string): boolean
    IsFinished: boolean
end

declare extern type DataStore with
    ClassName: string
    function GetAsync(self, key: string, options: DataStoreGetOptions?): (any, DataStoreKeyInfo)
    function GetVersionAsync(self, key: string, version: string): (any, DataStoreKeyInfo)
    function IncrementAsync(self, key: string, delta: number?, userIds: {number}?, options: DataStoreIncrementOptions?): (number, DataStoreKeyInfo)
    function IsA(self, className: string): boolean
    function ListKeysAsync(self, prefix: string?, pageSize: number?, cursor: string?, excludeDeleted: boolean?): DataStoreKeyPages
    function ListVersionsAsync(self, key: string, sortDirection: EnumItem?, minDate: number?, maxDate: number?, pageSize: number?): DataStoreVersionPages
    Name: string
    Parent: Instance
    function RemoveAsync(self, key: string): (any, DataStoreKeyInfo)
    @deprecated
    function RemoveVersionAsync(self, key: string, version: string): ()
    function SetAsync(self, key: string, value: any, userIds: {number}?, options: DataStoreSetOptions?): string
    function UpdateAsync(self, key: string, transform: (value: any, keyInfo: DataStoreKeyInfo?) -> (any, {number}?, {[string]: any}?)): (any, DataStoreKeyInfo)
end

declare extern type OrderedDataStore with
    ClassName: string
    function GetAsync(self, key: string): number?
    function GetSortedAsync(self, ascending: boolean, pageSize: number?, minValue: number?, maxValue: number?): DataStorePages
    function IncrementAsync(self, key: string, delta: number?): number
    function IsA(self, className: string): boolean
    Name: string
    Parent: Instance
    function RemoveAsync(self, key: string): number?
    function SetAsync(self, key: string, value: number): ()
    function UpdateAsync(self, key: string, transform: (value: number?, keyInfo: nil) -> number?): number?
end

declare extern type RunService with
    function BindToRenderStep(self, name: string, priority: number, callback: (deltaTime: number) -> ()): ()
    function BindToSimulation(self, callback: (deltaTime: number) -> (), frequency: EnumItem?, priority: number?): BVScriptConnection
    ClassName: string
    function GetPredictionStatus(self, instance: Instance): EnumItem
    function GetRenderedSessionTick(self, instance: Instance?): number
    function GetSessionTick(self): number
    Heartbeat: BVScriptSignal -- fires (number)
    function IsA(self, className: string): boolean
    function IsClient(self): boolean
    function IsEdit(self): boolean
    function IsResimulating(self): boolean
    function IsRunMode(self): boolean
    function IsRunning(self): boolean
    function IsServer(self): boolean
    function IsStudio(self): boolean
    Misprediction: BVScriptSignal -- fires (number, { { Instance: Instance, Properties: { [string]: { Predicted: any, Authoritative: any } }?, Attributes: { [string]: { Predicted: any, Authoritative: any } }? } }, { ResimulationTime: number })
    Name: string
    PostSimulation: BVScriptSignal -- fires (number)
    PreAnimation: BVScriptSignal -- fires (number)
    PreRender: BVScriptSignal -- fires (number)
    PreSimulation: BVScriptSignal -- fires (number)
    RenderStepped: BVScriptSignal -- fires (number)
    Rollback: BVScriptSignal -- fires (number)
    function SetCorrectionSmoothing(self, instance: Instance, enabled: boolean): ()
    function SetPredictionMode(self, instance: Instance, mode: EnumItem): ()
    Stepped: BVScriptSignal -- fires (number, number)
    function UnbindFromRenderStep(self, name: string): ()
end

declare extern type Players with
    CharacterAutoLoads: boolean
    ClassName: string
    function GetPlayerByUserId(self, userId: number): Player?
    function GetPlayerFromCharacter(self, character: Instance): Player?
    function GetPlayers(self): {Player}
    function IsA(self, className: string): boolean
    LocalPlayer: Player?
    Name: string
    PlayerAdded: BVScriptSignal -- fires (Player)
    PlayerRemoving: BVScriptSignal -- fires (Player)
    RespawnTime: number
    @deprecated
    function playerFromCharacter(self, character: Instance): Player?
end

declare extern type UserInputService with
    ClassName: string
    function GetFocusedTextBox(self): TextBox?
    function GetMouseDelta(self): Vector2
    function GetMouseLocation(self): Vector2
    InputBegan: BVScriptSignal -- fires ({ KeyCode: Enum.KeyCode, UserInputType: Enum.UserInputType }, boolean)
    InputEnded: BVScriptSignal -- fires ({ KeyCode: Enum.KeyCode, UserInputType: Enum.UserInputType }, boolean)
    function IsA(self, className: string): boolean
    function IsKeyDown(self, key: EnumItem): boolean
    MouseBehavior: EnumItem
    MouseIconEnabled: boolean
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
    ExposureCompensation: number
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

declare extern type HttpService with
    ClassName: string
    function GenerateGUID(self, wrapInCurlyBraces: boolean?): string
    function GetAsync(self, url: string, nocache: boolean?, headers: { [string]: string }?): string
    HttpEnabled: boolean
    function IsA(self, className: string): boolean
    function JSONDecode(self, input: string): any
    function JSONEncode(self, input: any): string
    Name: string
    function PostAsync(self, url: string, data: string, contentType: string?, compress: boolean?, headers: { [string]: string }?): string
    function RequestAsync(self, options: { Url: string, Method: string?, Headers: { [string]: string }?, Body: string? }): { Success: boolean, StatusCode: number, StatusMessage: string, Headers: { [string]: string }, Body: string }
end

declare extern type StarterGui with
    ClassName: string
    function GetCoreGuiEnabled(self, coreGuiType: EnumItem): boolean
    function IsA(self, className: string): boolean
    Name: string
    function SetCoreGuiEnabled(self, coreGuiType: EnumItem, enabled: boolean): ()
end

declare extern type DataStoreService with
    ClassName: string
    function GetDataStore(self, name: string, scope: string?, options: DataStoreOptions?): DataStore
    function GetGlobalDataStore(self): DataStore
    function GetOrderedDataStore(self, name: string, scope: string?): OrderedDataStore
    function GetRequestBudgetForRequestType(self, requestType: EnumItem): number
    function IsA(self, className: string): boolean
    function ListDataStoresAsync(self, prefix: string?, pageSize: number?, cursor: string?): DataStoreListingPages
    Name: string
end

declare extern type MessagingService with
    ClassName: string
    function IsA(self, className: string): boolean
    Name: string
    function PublishAsync(self, topic: string, message: any): ()
    function SubscribeAsync(self, topic: string, callback: (message: { Data: any, Sent: number }) -> ()): BVScriptConnection
end

declare extern type DataModel with
    GetService: ((self: DataModel, service: "Workspace") -> Workspace) & ((self: DataModel, service: "RunService") -> RunService) & ((self: DataModel, service: "Players") -> Players) & ((self: DataModel, service: "UserInputService") -> UserInputService) & ((self: DataModel, service: "SoundService") -> SoundService) & ((self: DataModel, service: "Lighting") -> Lighting) & ((self: DataModel, service: "Debris") -> Debris) & ((self: DataModel, service: "TweenService") -> TweenService) & ((self: DataModel, service: "CollectionService") -> CollectionService) & ((self: DataModel, service: "HttpService") -> HttpService) & ((self: DataModel, service: "StarterGui") -> StarterGui) & ((self: DataModel, service: "DataStoreService") -> DataStoreService) & ((self: DataModel, service: "MessagingService") -> MessagingService) & ((self: DataModel, service: "ReplicatedStorage") -> ReplicatedStorage) & ((self: DataModel, service: "ServerStorage") -> ServerStorage) & ((self: DataModel, service: "ServerScriptService") -> ServerScriptService) & ((self: DataModel, service: "StarterPlayerScripts") -> StarterPlayerScripts) & ((self: DataModel, service: string) -> Instance)
    function BindToClose(self, callback: (reason: EnumItem) -> ()): ()
    ClassName: string
    CollectionService: CollectionService
    DataStoreService: DataStoreService
    Debris: Debris
    GameId: number
    HttpService: HttpService
    function IsA(self, className: string): boolean
    JobId: string
    Lighting: Lighting
    MessagingService: MessagingService
    Name: string
    PlaceId: number
    Players: Players
    ReplicatedStorage: ReplicatedStorage
    RunService: RunService
    ServerScriptService: ServerScriptService
    ServerStorage: ServerStorage
    SoundService: SoundService
    StarterGui: StarterGui
    StarterPlayerScripts: StarterPlayerScripts
    TweenService: TweenService
    UserInputService: UserInputService
    Workspace: Workspace
    @deprecated
    function service(self, service: string): Instance
end

declare BrickColor: {
    Black: () -> BrickColor,
    Blue: () -> BrickColor,
    DarkGray: () -> BrickColor,
    Gray: () -> BrickColor,
    Green: () -> BrickColor,
    Random: () -> BrickColor,
    Red: () -> BrickColor,
    White: () -> BrickColor,
    Yellow: () -> BrickColor,
    new: (() -> BrickColor) & ((number: number) -> BrickColor) & ((name: string) -> BrickColor) & ((r: number, g: number, b: number) -> BrickColor) & ((color: Color3) -> BrickColor),
    palette: (index: number) -> BrickColor,
    random: () -> BrickColor,
}

declare CFrame: {
    Angles: (rx: number, ry: number, rz: number) -> CFrame,
    fromAxisAngle: (axis: Vector3, angle: number) -> CFrame,
    fromEulerAngles: (rx: number, ry: number, rz: number, order: EnumItem?) -> CFrame,
    fromEulerAnglesXYZ: (rx: number, ry: number, rz: number) -> CFrame,
    fromEulerAnglesYXZ: (rx: number, ry: number, rz: number) -> CFrame,
    fromMatrix: (pos: Vector3, vX: Vector3, vY: Vector3, vZ: Vector3?) -> CFrame,
    fromOrientation: (rx: number, ry: number, rz: number) -> CFrame,
    fromRotationBetweenVectors: (from: Vector3, to: Vector3) -> CFrame,
    identity: CFrame,
    lookAlong: (position: Vector3, direction: Vector3, up: Vector3?) -> CFrame,
    lookAt: (position: Vector3, target: Vector3, up: Vector3?) -> CFrame,
    new: (() -> CFrame) & ((position: Vector3) -> CFrame) & ((position: Vector3, lookAt: Vector3) -> CFrame) & ((x: number, y: number, z: number) -> CFrame) & ((x: number, y: number, z: number, qX: number, qY: number, qZ: number, qW: number) -> CFrame) & ((x: number, y: number, z: number, R00: number, R01: number, R02: number, R10: number, R11: number, R12: number, R20: number, R21: number, R22: number) -> CFrame),
}

declare Color3: {
    fromHSV: (h: number, s: number, v: number) -> Color3,
    fromHex: (hex: string) -> Color3,
    fromRGB: (r: number, g: number, b: number) -> Color3,
    new: (r: number?, g: number?, b: number?) -> Color3,
    toHSV: (color: Color3) -> (number, number, number), -- deprecated
}

declare ColorSequence: {
    new: ((color: Color3) -> ColorSequence) & ((color0: Color3, color1: Color3) -> ColorSequence) & ((keypoints: {ColorSequenceKeypoint}) -> ColorSequence),
}

declare ColorSequenceKeypoint: {
    new: (time: number, color: Color3) -> ColorSequenceKeypoint,
}

declare Font: {
    fromEnum: (font: EnumItem) -> Font,
    new: (family: string, weight: EnumItem?, style: EnumItem?) -> Font,
}

declare Instance: {
    new: ((className: "AlignOrientation") -> AlignOrientation) & ((className: "AlignPosition") -> AlignPosition) & ((className: "AngularVelocity") -> AngularVelocity) & ((className: "Attachment") -> Attachment) & ((className: "BallSocketConstraint") -> BallSocketConstraint) & ((className: "BillboardGui") -> BillboardGui) & ((className: "BindableEvent") -> BindableEvent) & ((className: "BindableFunction") -> BindableFunction) & ((className: "BoolValue") -> BoolValue) & ((className: "Camera") -> Camera) & ((className: "ClickDetector") -> ClickDetector) & ((className: "DataStoreGetOptions") -> DataStoreGetOptions) & ((className: "DataStoreIncrementOptions") -> DataStoreIncrementOptions) & ((className: "DataStoreOptions") -> DataStoreOptions) & ((className: "DataStoreSetOptions") -> DataStoreSetOptions) & ((className: "Folder") -> Folder) & ((className: "Frame") -> Frame) & ((className: "HingeConstraint") -> HingeConstraint) & ((className: "Humanoid") -> Humanoid) & ((className: "ImageLabel") -> ImageLabel) & ((className: "InputAction") -> InputAction) & ((className: "InputBinding") -> InputBinding) & ((className: "InputContext") -> InputContext) & ((className: "IntValue") -> IntValue) & ((className: "LinearVelocity") -> LinearVelocity) & ((className: "MeshPart") -> MeshPart) & ((className: "Model") -> Model) & ((className: "NumberValue") -> NumberValue) & ((className: "ObjectValue") -> ObjectValue) & ((className: "Part") -> Part) & ((className: "ParticleEmitter") -> ParticleEmitter) & ((className: "PointLight") -> PointLight) & ((className: "RemoteEvent") -> RemoteEvent) & ((className: "RemoteFunction") -> RemoteFunction) & ((className: "RodConstraint") -> RodConstraint) & ((className: "RopeConstraint") -> RopeConstraint) & ((className: "ScreenGui") -> ScreenGui) & ((className: "Sound") -> Sound) & ((className: "SoundGroup") -> SoundGroup) & ((className: "SpotLight") -> SpotLight) & ((className: "SpringConstraint") -> SpringConstraint) & ((className: "StringValue") -> StringValue) & ((className: "TextBox") -> TextBox) & ((className: "TextButton") -> TextButton) & ((className: "TextLabel") -> TextLabel) & ((className: "Torque") -> Torque) & ((className: "UICorner") -> UICorner) & ((className: "UIGradient") -> UIGradient) & ((className: "UIListLayout") -> UIListLayout) & ((className: "UIPadding") -> UIPadding) & ((className: "UIStroke") -> UIStroke) & ((className: "VectorForce") -> VectorForce) & ((className: "Weld") -> Weld) & ((className: "WeldConstraint") -> WeldConstraint) & ((className: string) -> Instance),
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

declare Random: {
    new: (seed: number?) -> Random,
}

declare Ray: {
    new: (origin: Vector3, direction: Vector3) -> Ray,
}

declare RaycastParams: {
    new: () -> RaycastParams,
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

export type Enum = {
    FromName: (self: Enum, name: string) -> EnumItem?,
    FromValue: (self: Enum, value: number) -> EnumItem?,
    GetEnumItems: (self: Enum) -> {EnumItem},
}

declare Enum: {
    GetEnums: (self: any) -> {Enum},
    ActuatorRelativeTo: Enum & { Attachment0: EnumItem, Attachment1: EnumItem, World: EnumItem },
    ActuatorType: Enum & { Motor: EnumItem, None: EnumItem, Servo: EnumItem },
    AlignType: Enum & { AllAxes: EnumItem, Parallel: EnumItem, Perpendicular: EnumItem, PrimaryAxisLookAt: EnumItem, PrimaryAxisParallel: EnumItem, PrimaryAxisPerpendicular: EnumItem },
    ApplyStrokeMode: Enum & { Border: EnumItem, Contextual: EnumItem },
    AuthorityMode: Enum & { Automatic: EnumItem, Server: EnumItem },
    CameraType: Enum & { Attach: EnumItem, Custom: EnumItem, Fixed: EnumItem, Follow: EnumItem, Orbital: EnumItem, Scriptable: EnumItem, Track: EnumItem, Watch: EnumItem },
    CloseReason: Enum & { DeveloperShutdown: EnumItem, DeveloperUpdate: EnumItem, Moderation: EnumItem, OutOfMemory: EnumItem, RobloxMaintenance: EnumItem, ServerEmpty: EnumItem, Unknown: EnumItem },
    CollisionFidelity: Enum & { Box: EnumItem, Default: EnumItem, Hull: EnumItem, PreciseConvexDecomposition: EnumItem },
    CoreGuiType: Enum & { All: EnumItem, AvatarSwitcher: EnumItem, Backpack: EnumItem, Captures: EnumItem, Chat: EnumItem, EmotesMenu: EnumItem, ExperienceShop: EnumItem, Health: EnumItem, PlayerList: EnumItem, SelfView: EnumItem },
    DataStoreRequestType: Enum & { GetAsync: EnumItem, GetSortedAsync: EnumItem, GetVersionAsync: EnumItem, ListAsync: EnumItem, OnUpdate: EnumItem, OrderedList: EnumItem, OrderedRead: EnumItem, OrderedRemove: EnumItem, OrderedWrite: EnumItem, RemoveVersionAsync: EnumItem, SetIncrementAsync: EnumItem, SetIncrementSortedAsync: EnumItem, StandardList: EnumItem, StandardRead: EnumItem, StandardRemove: EnumItem, StandardWrite: EnumItem, UpdateAsync: EnumItem },
    EasingDirection: Enum & { In: EnumItem, InOut: EnumItem, Out: EnumItem },
    EasingStyle: Enum & { Back: EnumItem, Bounce: EnumItem, Circular: EnumItem, Cubic: EnumItem, Elastic: EnumItem, Exponential: EnumItem, Linear: EnumItem, Quad: EnumItem, Quart: EnumItem, Quint: EnumItem, Sine: EnumItem },
    FieldOfViewMode: Enum & { Diagonal: EnumItem, MaxAxis: EnumItem, Vertical: EnumItem },
    FillDirection: Enum & { Horizontal: EnumItem, Vertical: EnumItem },
    Font: Enum & { AmaticSC: EnumItem, Antique: EnumItem, Arcade: EnumItem, Arial: EnumItem, ArialBold: EnumItem, Arimo: EnumItem, ArimoBold: EnumItem, Bangers: EnumItem, Bodoni: EnumItem, BuilderSans: EnumItem, BuilderSansBold: EnumItem, BuilderSansExtraBold: EnumItem, BuilderSansMedium: EnumItem, Cartoon: EnumItem, Code: EnumItem, Creepster: EnumItem, DenkOne: EnumItem, Fantasy: EnumItem, Fondamento: EnumItem, FredokaOne: EnumItem, Garamond: EnumItem, Gotham: EnumItem, GothamBlack: EnumItem, GothamBold: EnumItem, GothamMedium: EnumItem, GrenzeGotisch: EnumItem, Highway: EnumItem, IndieFlower: EnumItem, JosefinSans: EnumItem, Jura: EnumItem, Kalam: EnumItem, Legacy: EnumItem, LuckiestGuy: EnumItem, Merriweather: EnumItem, Michroma: EnumItem, Nunito: EnumItem, Oswald: EnumItem, PatrickHand: EnumItem, PermanentMarker: EnumItem, Roboto: EnumItem, RobotoCondensed: EnumItem, RobotoMono: EnumItem, Sarpanch: EnumItem, SciFi: EnumItem, SourceSans: EnumItem, SourceSansBold: EnumItem, SourceSansItalic: EnumItem, SourceSansLight: EnumItem, SourceSansSemibold: EnumItem, SpecialElite: EnumItem, TitilliumWeb: EnumItem, Ubuntu: EnumItem, Unknown: EnumItem },
    FontStyle: Enum & { Italic: EnumItem, Normal: EnumItem },
    FontWeight: Enum & { Bold: EnumItem, ExtraBold: EnumItem, ExtraLight: EnumItem, Heavy: EnumItem, Light: EnumItem, Medium: EnumItem, Regular: EnumItem, SemiBold: EnumItem, Thin: EnumItem },
    ForceLimitMode: Enum & { Magnitude: EnumItem, PerAxis: EnumItem },
    HorizontalAlignment: Enum & { Center: EnumItem, Left: EnumItem, Right: EnumItem },
    HumanoidStateType: Enum & { Climbing: EnumItem, Dead: EnumItem, FallingDown: EnumItem, Flying: EnumItem, Freefall: EnumItem, GettingUp: EnumItem, Jumping: EnumItem, Landed: EnumItem, None: EnumItem, Physics: EnumItem, PlatformStanding: EnumItem, Ragdoll: EnumItem, Running: EnumItem, RunningNoPhysics: EnumItem, Seated: EnumItem, StrafingNoPhysics: EnumItem, Swimming: EnumItem },
    InputActionType: Enum & { Bool: EnumItem, Direction1D: EnumItem, Direction2D: EnumItem, Direction3D: EnumItem },
    KeyCode: Enum & { A: EnumItem, B: EnumItem, BackSlash: EnumItem, Backquote: EnumItem, Backspace: EnumItem, C: EnumItem, CapsLock: EnumItem, Comma: EnumItem, D: EnumItem, Delete: EnumItem, Down: EnumItem, E: EnumItem, Eight: EnumItem, End: EnumItem, Equals: EnumItem, Escape: EnumItem, F: EnumItem, F1: EnumItem, F10: EnumItem, F11: EnumItem, F12: EnumItem, F2: EnumItem, F3: EnumItem, F4: EnumItem, F5: EnumItem, F6: EnumItem, F7: EnumItem, F8: EnumItem, F9: EnumItem, Five: EnumItem, Four: EnumItem, G: EnumItem, H: EnumItem, Home: EnumItem, I: EnumItem, Insert: EnumItem, J: EnumItem, K: EnumItem, L: EnumItem, Left: EnumItem, LeftAlt: EnumItem, LeftBracket: EnumItem, LeftControl: EnumItem, LeftShift: EnumItem, M: EnumItem, Minus: EnumItem, N: EnumItem, Nine: EnumItem, None: EnumItem, O: EnumItem, One: EnumItem, P: EnumItem, PageDown: EnumItem, PageUp: EnumItem, Period: EnumItem, Q: EnumItem, Quote: EnumItem, R: EnumItem, Return: EnumItem, Right: EnumItem, RightAlt: EnumItem, RightBracket: EnumItem, RightControl: EnumItem, RightShift: EnumItem, S: EnumItem, Semicolon: EnumItem, Seven: EnumItem, Six: EnumItem, Slash: EnumItem, Space: EnumItem, T: EnumItem, Tab: EnumItem, Three: EnumItem, Two: EnumItem, U: EnumItem, Unknown: EnumItem, Up: EnumItem, V: EnumItem, W: EnumItem, X: EnumItem, Y: EnumItem, Z: EnumItem, Zero: EnumItem },
    Material: Enum & { Brick: EnumItem, Concrete: EnumItem, Glass: EnumItem, Grass: EnumItem, Metal: EnumItem, Neon: EnumItem, Plastic: EnumItem, Slate: EnumItem, SmoothPlastic: EnumItem, Wood: EnumItem },
    MouseBehavior: Enum & { Default: EnumItem, LockCenter: EnumItem, LockCurrentPosition: EnumItem },
    NormalId: Enum & { Back: EnumItem, Bottom: EnumItem, Front: EnumItem, Left: EnumItem, Right: EnumItem, Top: EnumItem },
    OrientationAlignmentMode: Enum & { OneAttachment: EnumItem, TwoAttachment: EnumItem },
    PartType: Enum & { Ball: EnumItem, Block: EnumItem, CornerWedge: EnumItem, Cylinder: EnumItem, Wedge: EnumItem },
    ParticleEmitterShape: Enum & { Box: EnumItem, Cylinder: EnumItem, Disc: EnumItem, Sphere: EnumItem },
    ParticleEmitterShapeInOut: Enum & { InAndOut: EnumItem, Inward: EnumItem, Outward: EnumItem },
    ParticleEmitterShapeStyle: Enum & { Surface: EnumItem, Volume: EnumItem },
    ParticleFlipbookLayout: Enum & { Custom: EnumItem, Grid2x2: EnumItem, Grid4x4: EnumItem, Grid8x8: EnumItem, None: EnumItem },
    ParticleFlipbookMode: Enum & { Loop: EnumItem, OneShot: EnumItem, PingPong: EnumItem, Random: EnumItem },
    ParticleOrientation: Enum & { FacingCamera: EnumItem, FacingCameraWorldUp: EnumItem, VelocityParallel: EnumItem, VelocityPerpendicular: EnumItem },
    PlaybackState: Enum & { Begin: EnumItem, Cancelled: EnumItem, Completed: EnumItem, Delayed: EnumItem, Paused: EnumItem, Playing: EnumItem },
    PositionAlignmentMode: Enum & { OneAttachment: EnumItem, TwoAttachment: EnumItem },
    PredictionMode: Enum & { Automatic: EnumItem, Off: EnumItem, On: EnumItem },
    PredictionStatus: Enum & { Authoritative: EnumItem, None: EnumItem, Predicted: EnumItem },
    RaycastFilterType: Enum & { Blacklist: EnumItem, Exclude: EnumItem, Include: EnumItem, Whitelist: EnumItem },
    RenderPriority: Enum & { Camera: EnumItem, Character: EnumItem, First: EnumItem, Input: EnumItem, Last: EnumItem },
    RollOffMode: Enum & { Inverse: EnumItem, InverseTapered: EnumItem, Linear: EnumItem, LinearSquare: EnumItem },
    RotationOrder: Enum & { XYZ: EnumItem, XZY: EnumItem, YXZ: EnumItem, YZX: EnumItem, ZXY: EnumItem, ZYX: EnumItem },
    RunContext: Enum & { Client: EnumItem, Legacy: EnumItem, Server: EnumItem },
    SortDirection: Enum & { Ascending: EnumItem, Descending: EnumItem },
    SortOrder: Enum & { Custom: EnumItem, LayoutOrder: EnumItem, Name: EnumItem },
    StepFrequency: Enum & { Hz1: EnumItem, Hz10: EnumItem, Hz15: EnumItem, Hz30: EnumItem, Hz5: EnumItem, Hz60: EnumItem },
    TextXAlignment: Enum & { Center: EnumItem, Left: EnumItem, Right: EnumItem },
    TextYAlignment: Enum & { Bottom: EnumItem, Center: EnumItem, Top: EnumItem },
    UserInputType: Enum & { Keyboard: EnumItem, MouseButton1: EnumItem, MouseButton2: EnumItem, MouseButton3: EnumItem },
    VelocityConstraintMode: Enum & { Line: EnumItem, Plane: EnumItem, Vector: EnumItem },
    VerticalAlignment: Enum & { Bottom: EnumItem, Center: EnumItem, Top: EnumItem },
}

declare function warn(...: any): ()
declare function collectgarbage(mode: "count"): number

declare debug: {
    info: ((thread: thread, level: number, options: string) -> ...any) & ((level: number, options: string) -> ...any) & ((fun: (...any) -> ...any, options: string) -> ...any),
    traceback: ((message: string?, level: number?) -> string) & ((thread: thread, message: string?, level: number?) -> string),
    profilebegin: (label: string) -> (),
    profileend: () -> (),
    dumpcodesize: () -> (),
    setmemorycategory: (tag: string) -> string,
    resetmemorycategory: () -> (),
    getmemorycategory: () -> string,
}

declare task: {
    wait: (duration: number?) -> number,
    spawn: <A...>(f: ((A...) -> ()) | thread, A...) -> thread,
    defer: <A...>(f: ((A...) -> ()) | thread, A...) -> thread,
    delay: <A...>(duration: number, f: ((A...) -> ()) | thread, A...) -> thread,
    cancel: (thread: thread) -> (),
    synchronize: () -> (),
    desynchronize: () -> (),
}

declare Signals: {
    Get: (name: string) -> BVScriptSignal,
    Fire: (name: string, ...any) -> (),
}

declare Keybinds: { [string]: BVScriptSignal }

declare function wait(seconds: number?): (number, number)
declare function spawn(callback: (number, number) -> ()): ()
declare function delay(delayTime: number?, callback: (number, number) -> ()): ()
declare function tick(): number
declare function time(): number
declare function elapsedTime(): number

declare workspace: Workspace
declare script: LuaSourceContainer
declare game: DataModel
