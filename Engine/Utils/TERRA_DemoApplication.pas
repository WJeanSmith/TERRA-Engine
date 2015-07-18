Unit TERRA_DemoApplication;

{$I terra.inc}

Interface
Uses TERRA_Utils, TERRA_Object, TERRA_String, TERRA_Application, TERRA_OS, TERRA_Scene,
  TERRA_Vector3D, TERRA_Color,
  TERRA_Font, TERRA_Skybox, TERRA_Viewport, TERRA_Lights;

Type
  DemoApplication = Class;

  DemoScene = Class(TERRAScene)
    Private
      _Owner:DemoApplication;
      _Sky:TERRASkybox;
      _Sun:DirectionalLight;
      _Main:TERRAViewport;

    Public
      Constructor Create(Owner:DemoApplication);
      Procedure Release; Override;

      Procedure RenderSprites(V:TERRAViewport); Override;
      Procedure RenderViewport(V:TERRAViewport); Override;

      Property Sun:DirectionalLight Read _Sun;
      Property MainViewport:TERRAViewport Read _Main;
  End;

  DemoApplication = Class(Application)
    Protected
      _Scene:DemoScene;
      _Font:TERRAFont;

    Public
			Procedure OnCreate; Override;
			Procedure OnDestroy; Override;
			Procedure OnIdle; Override;

      Procedure OnRender(V:TERRAViewport); Virtual;

      Property Font:TERRAFont Read _Font;
      Property Scene:DemoScene Read _Scene;
  End;

Implementation
Uses TERRA_FileManager, TERRA_InputManager, TERRA_GraphicsManager;

{ Demo }
Procedure DemoApplication.OnCreate;
Begin
  Inherited;

  FileManager.Instance.AddPath('Assets');

  _Font := FontManager.Instance.DefaultFont;

  _Scene := DemoScene.Create(Self);
  GraphicsManager.Instance.Scene := _Scene;
End;

Procedure DemoApplication.OnDestroy;
Begin
  ReleaseObject(_Scene);
End;

Procedure DemoApplication.OnIdle;
Begin
  If InputManager.Instance.Keys.WasPressed(keyEscape) Then
    Application.Instance.Terminate();

  GraphicsManager.Instance.TestDebugKeys();

  _Scene.MainViewport.Camera.FreeCam;
End;

{ DemoScene }
Constructor DemoScene.Create(Owner:DemoApplication);
Begin
  Inherited Create();

  Self._Owner := Owner;
  _Sun := DirectionalLight.Create(VectorCreate(-0.25, 0.75, 0.0));
  _Sky := TERRASkybox.Create('sky');

  _Main := GraphicsManager.Instance.CreateMainViewport('main', GraphicsManager.Instance.Width, GraphicsManager.Instance.Height);
  _Main.SetPostProcessingState(True);
End;

Procedure DemoScene.Release;
Begin
  Inherited;

  ReleaseObject(_Sun);
  ReleaseObject(_Sky);
End;

Procedure DemoScene.RenderSprites(V: TERRAViewport);
Begin
End;

Procedure DemoScene.RenderViewport(V: TERRAViewport);
Begin
  GraphicsManager.Instance.AddRenderable(V, _Sky);
  LightManager.Instance.AddLight(V, Sun);

  _Owner.OnRender(V);
End;

Procedure DemoApplication.OnRender(V: TERRAViewport);
Begin
End;

End.
