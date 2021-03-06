Unit TERRA_ShaderNode;

{$I terra.inc}

Interface
Uses TERRA_Utils, TERRA_Object, TERRA_String, TERRA_ShaderCompiler, TERRA_VertexFormat,
  TERRA_Vector2D, TERRA_Vector3D, TERRA_Vector4D, TERRA_Matrix3x3, TERRA_Matrix4x4;


// http://acegikmo.com/shaderforge/nodes/

Const
  vectorComponentX = 1;
  vectorComponentY = 2;
  vectorComponentZ = 4;
  vectorComponentW = 8;

Type
  TERRAShaderNode = Class;
  TERRAShaderGroup = Class;

        { TERRAShaderNode }

 TERRAShaderNode = Class(TERRAObject)
		Protected
      _Block:ShaderBlock;

      Function IsVector(T:ShaderNodeType):Boolean;
      Function IsMatrix(T:ShaderNodeType):Boolean;
      Function IsSampler(T:ShaderNodeType):Boolean;

      // should tell the target compiler what basic primitve method this node represents
      Function Compile(Target:ShaderCompiler):Boolean; Virtual;
      
		Public
      // should return type of output (or invalid if problems found)
      Function GetType():ShaderNodeType; Virtual;

      // should return false if there are problems with inputs, otherwise returns true
      Function Validate():Boolean; Virtual;

      Function GetSubNodeAt(Index:Integer):TERRAShaderNode; Virtual;
      Function GetSubNodeCount():Integer; Virtual;

      // should return a sub graph for complex nodes, nil for others
      Function GetSubGraph():TERRAShaderGroup; Virtual;
	End;

	TERRAShaderGroup = Class(TERRAShaderNode)
		Private
			_Nodes:Array Of TERRAShaderNode;
			_NodeCount:Integer;

		Public
      XVertexCode:TERRAString;
      XFragmentCode:TERRAString;

      Constructor Create(Const Name:TERRAString);

      Procedure AddNode(Node:TERRAShaderNode);

      Function GenerateCode(Target:TERRAShaderNode; Compiler:ShaderCompiler; Out VertexShader, FragmentShader:TERRAString):Boolean;

      Function GetSubNodeAt(Index:Integer):TERRAShaderNode; Override;
      Function GetSubNodeCount():Integer; Override;
	End;

	// constant
	ShaderFloatConstant = Class(TERRAShaderNode)
		Protected
			_Value:Single;

      Function Compile(Target:ShaderCompiler):Boolean; Override;

		Public
      Constructor Create(Const N:Single);

			Function GetType():ShaderNodeType; Override;

			Property Value:Single Read _Value Write _Value;
	End;

	ShaderVec2Constant = Class(TERRAShaderNode)
		Protected
			_Value:Vector2D;

      Function Compile(Target:ShaderCompiler):Boolean; Override;

		Public
      Constructor Create(Const V:Vector2D);

			Function GetType():ShaderNodeType; Override;

			Property Value:Vector2D Read _Value Write _Value;
	End;

	ShaderVec3Constant = Class(TERRAShaderNode)
		Protected
			_Value:Vector3D;

      Function Compile(Target:ShaderCompiler):Boolean; Override;
      
		Public
      Constructor Create(Const V:Vector3D);

			Function GetType():ShaderNodeType; Override;

			Property Value:Vector3D Read _Value Write _Value;
	End;


	ShaderVec4Constant = Class(TERRAShaderNode)
		Protected
			_Value:Vector4D;

      Function Compile(Target:ShaderCompiler):Boolean; Override;

		Public
      Constructor Create(Const V:Vector4D);

			Function GetType():ShaderNodeType; Override;

			Property Value:Vector4D Read _Value Write _Value;
	End;

	ShaderUniformNode = Class(TERRAShaderNode)
		Protected
      _Name:TERRAString;
      _Type:ShaderNodeType;

      Function Compile(Target:ShaderCompiler):Boolean; Override;

		Public
			Function GetType():ShaderNodeType; Override;
	End;

	ShaderAttributeNode = Class(TERRAShaderNode)
		Protected
      _Name:TERRAString;
      _Kind:VertexFormatAttribute;
      _Type:ShaderNodeType;

      Function Compile(Target:ShaderCompiler):Boolean; Override;

		Public
      Constructor Create(Const Name:TERRAString; AttrKind:VertexFormatAttribute; AttrType:ShaderNodeType);

      Property AttributeKind:VertexFormatAttribute Read _Kind Write _Kind;
      Property AttributeType:ShaderNodeType Read _Type Write _Type;

			Function GetType():ShaderNodeType; Override;
	End;

	// shader unary nodes
	ShaderUnaryNode = Class(TERRAShaderNode)
		Protected
			_Input:TERRAShaderNode;

      Procedure SetInput(const Value: TERRAShaderNode);
		Public
			Function GetType():ShaderNodeType; Override;

      Function GetSubNodeAt(Index:Integer):TERRAShaderNode; Override;
      Function GetSubNodeCount():Integer; Override;

			Property Input:TERRAShaderNode Read _Input Write SetInput;
	End;

	ShaderUnaryFunctionNode = Class(ShaderUnaryNode)
		Protected
      _Func:ShaderFunctionType;

      Function Compile(Target:ShaderCompiler):Boolean; Override;

		Public
      Property FunctionType:ShaderFunctionType Read _Func Write _Func;

      Function Validate():Boolean; Override;
      Function GetType():ShaderNodeType; Override;
	End;

	ShaderOutputNode = Class(ShaderUnaryNode)
		Protected
      _Output:ShaderOutputType;

      Function Compile(Target:ShaderCompiler):Boolean; Override;

		Public
      Constructor Create(Kind:ShaderOutputType);

      Property OutputType:ShaderOutputType Read _Output Write _Output;

			Function GetType():ShaderNodeType; Override;
	End;

	// shader binary nodes
	ShaderBinaryNode = Class(TERRAShaderNode)
		Protected
			_A:TERRAShaderNode;
			_B:TERRAShaderNode;
      _Func:ShaderFunctionType;

      Procedure SetInputA(const Value: TERRAShaderNode);
      Procedure SetInputB(const Value: TERRAShaderNode);
		Public
			Function GetType():ShaderNodeType; Override;
      Function Validate():Boolean; Override;

      Function GetSubNodeAt(Index:Integer):TERRAShaderNode; Override;
      Function GetSubNodeCount():Integer; Override;

			Property InputA:TERRAShaderNode Read _A Write SetInputA;
			Property InputB:TERRAShaderNode Read _B Write SetInputB;

      Property FunctionType:ShaderFunctionType Read _Func Write _Func;
	End;

	ShaderBinaryFunctionNode = Class(ShaderBinaryNode)
		Protected
      _Func:ShaderFunctionType;

      Function Compile(Target:ShaderCompiler):Boolean; Override;

		Public
			Function GetType():ShaderNodeType; Override;

      Property FunctionType:ShaderFunctionType Read _Func Write _Func;
	End;

  ShaderBinaryOptionNode = Class(ShaderBinaryNode)
    Protected
      _Option:Cardinal;

      Function Compile(Target:ShaderCompiler):Boolean; Override;

    Public
  End;

	ShaderTernaryNode = Class(TERRAShaderNode)
		Protected
			_A:TERRAShaderNode;
			_B:TERRAShaderNode;
			_C:TERRAShaderNode;

      Procedure SetInputA(const Value: TERRAShaderNode);
      Procedure SetInputB(const Value: TERRAShaderNode);
      Procedure SetInputC(const Value: TERRAShaderNode);

		Public
			Function GetType():ShaderNodeType; Override;
      Function Validate():Boolean; Override;

      Function GetSubNodeAt(Index:Integer):TERRAShaderNode; Override;
      Function GetSubNodeCount():Integer; Override;

			Property InputA:TERRAShaderNode Read _A Write SetInputA;
			Property InputB:TERRAShaderNode Read _B Write SetInputB;
			Property InputC:TERRAShaderNode Read _C Write SetInputC;
	End;

	ShaderTernaryFunctionNode = Class(ShaderTernaryNode)
		Protected
      _Func:ShaderFunctionType;

      Function Compile(Target:ShaderCompiler):Boolean; Override;

		Public
      Property FunctionType:ShaderFunctionType Read _Func Write _Func;
	End;

	// extract xyzw components from vectors
	ShaderVectorComponent = Class(ShaderUnaryNode)
		Protected
			_Mask:Cardinal;

      Function Compile(Target:ShaderCompiler):Boolean; Override;

		Public
			Function GetType():ShaderNodeType; Override;
      Function Validate():Boolean; Override;

			Property Mask:Cardinal Read _Mask Write _Mask;
	End;

	ShaderSamplerNode = Class(ShaderBinaryNode)
    Protected
      Function Compile(Target:ShaderCompiler):Boolean; Override;

		Public
      Function Validate():Boolean; Override;

			Function GetType():ShaderNodeType; Override;
	End;

Implementation

{ TERRAShaderNode }
function TERRAShaderNode.GetSubGraph: TERRAShaderGroup;
Begin
  Result := Nil;
End;

function TERRAShaderNode.IsMatrix(T: ShaderNodeType): Boolean;
Begin
  Result := (T = ShaderNode_Matrix3x3) Or (T = ShaderNode_Matrix4x4);
End;

function TERRAShaderNode.IsSampler(T: ShaderNodeType): Boolean;
Begin
  Result := (T = ShaderNode_Texture2D) Or (T = ShaderNode_Cubemap);
End;

function TERRAShaderNode.IsVector(T: ShaderNodeType): Boolean;
Begin
  Result := (T = ShaderNode_Vector2D) Or (T = ShaderNode_Vector3D) Or (T = ShaderNode_Vector4D);
End;

function TERRAShaderNode.Validate: Boolean;
Begin
  Result := True;
End;

function TERRAShaderNode.GetSubNodeAt(Index: Integer): TERRAShaderNode;
Begin
  Result := Nil;
End;

function TERRAShaderNode.GetSubNodeCount: Integer;
Begin
  Result := 0;
End;

function TERRAShaderNode.Compile(Target: ShaderCompiler): Boolean;
Begin
  Result := False;
End;

function TERRAShaderNode.GetType: ShaderNodeType;
begin
  Result := ShaderNode_Invalid;
end;

{ ShaderFloatConstant }
Function ShaderFloatConstant.Compile(Target: ShaderCompiler): Boolean;
Begin
  _Block := Target.GenerateFloatConstant(_Value);
  Result := Assigned(_Block);
End;

Constructor ShaderFloatConstant.Create(const N: Single);
Begin
  Self.Value := N;
End;

Function ShaderFloatConstant.GetType: ShaderNodeType;
Begin
  Result := ShaderNode_Float;
End;

{ ShaderVec2Constant }
Function ShaderVec2Constant.Compile(Target: ShaderCompiler): Boolean;
Begin
  _Block := Target.GenerateVec2Constant(_Value);
  Result := Assigned(_Block);
End;

Constructor ShaderVec2Constant.Create(const V: Vector2D);
Begin
  Self.Value := V;
End;

Function ShaderVec2Constant.GetType: ShaderNodeType;
Begin
  Result := ShaderNode_Vector2D;
End;

{ ShaderVec3Constant }
Function ShaderVec3Constant.Compile(Target: ShaderCompiler): Boolean;
Begin
  _Block := Target.GenerateVec3Constant(Value);
  Result := Assigned(_Block);
End;

Constructor ShaderVec3Constant.Create(const V: Vector3D);
Begin
  Self.Value := V;
End;

Function ShaderVec3Constant.GetType: ShaderNodeType;
Begin
  Result := ShaderNode_Vector3D;
End;

{ ShaderVec4Constant }
Function ShaderVec4Constant.Compile(Target: ShaderCompiler): Boolean;
Begin
  _Block := Target.GenerateVec4Constant(Value);
  Result := Assigned(_Block);
End;

Constructor ShaderVec4Constant.Create(const V: Vector4D);
Begin
  Self.Value := V;
End;

Function ShaderVec4Constant.GetType: ShaderNodeType;
Begin
  Result := ShaderNode_Vector4D;
End;

{ ShaderUnaryNode }
Function ShaderUnaryNode.GetType: ShaderNodeType;
Begin
  Result := _Input.GetType();
End;


Function ShaderUnaryNode.GetSubNodeAt(Index:Integer):TERRAShaderNode;
Begin
  Result := Nil;
End;

Function ShaderUnaryNode.GetSubNodeCount():Integer;
Begin
  Result := 2;
End;

Procedure ShaderUnaryNode.SetInput(const Value: TERRAShaderNode);
Begin
  Self._Input := Value;
End;

{ ShaderVectorComponent }
Function ShaderVectorComponent.Compile(Target: ShaderCompiler): Boolean;
Begin
  Result := Self._Input.Compile(Target);
  If Not Result Then
    Exit;

  _Block := Target.GenerateSwizzle(_Input._Block, _Mask);
  Result := Assigned(_Block);
End;

Function ShaderVectorComponent.GetType: ShaderNodeType;
Var
  Count:Integer;
Begin
  Count := 0;

  If ((_Mask And vectorComponentX)<>0) Then
    Inc(Count);

  If ((_Mask And vectorComponentY)<>0) Then
    Inc(Count);

  If ((_Mask And vectorComponentZ)<>0) Then
    Inc(Count);

  If ((_Mask And vectorComponentW)<>0) Then
    Inc(Count);


  Case Count Of
  1:  Result := ShaderNode_Float;
  2:  Result := ShaderNode_Vector2D;
  3:  Result := ShaderNode_Vector3D;
  4:  Result := ShaderNode_Vector4D;
  Else
    Result := ShaderNode_Invalid;
  End;
End;

Function ShaderVectorComponent.Validate: Boolean;
Begin
  Result := Inherited Validate;
  Result := (Result) And (Self.Mask<>0);
End;

{ ShaderBinaryNode }
Function ShaderBinaryNode.GetType: ShaderNodeType;
Begin
  Result := _A.GetType();

  If _B.GetType() <> Result Then
    Result := ShaderNode_Invalid;
End;

Function ShaderBinaryNode.Validate: Boolean;
Begin
  Result := (_A.GetType() = _B.GetType());
End;

Function ShaderBinaryNode.GetSubNodeAt(Index:Integer):TERRAShaderNode;
Begin
  Case Index Of
  0: Result := _A;
  1: Result := _B;
  Else
    Result := Nil;
  End;
End;

Function ShaderBinaryNode.GetSubNodeCount():Integer;
Begin
  Result := 2;
End;

Procedure ShaderBinaryNode.SetInputA(const Value: TERRAShaderNode);
Begin
  _A := Value;
End;

Procedure ShaderBinaryNode.SetInputB(const Value: TERRAShaderNode);
Begin
  _B := Value;
End;

{ ShaderTernaryNode }
Function ShaderTernaryNode.GetType: ShaderNodeType;
Begin
  Result := _A.GetType();

  If _B.GetType() <> Result Then
    Result := ShaderNode_Invalid;
End;

Function ShaderTernaryNode.Validate: Boolean;
Begin
  Result := (_A.GetType() = _B.GetType());
End;

Function ShaderTernaryNode.GetSubNodeAt(Index:Integer):TERRAShaderNode;
Begin
  Case Index Of
  0: Result := _A;
  1: Result := _B;
  2: Result := _C;
  Else
    Result := Nil;
  End;
End;

Function ShaderTernaryNode.GetSubNodeCount():Integer;
Begin
  Result := 3;
End;

Procedure ShaderTernaryNode.SetInputA(const Value: TERRAShaderNode);
Begin
  _A := Value;
End;

Procedure ShaderTernaryNode.SetInputB(const Value: TERRAShaderNode);
Begin
  _B := Value;
End;

Procedure ShaderTernaryNode.SetInputC(const Value: TERRAShaderNode);
Begin
  _C := Value;
End;


{ ShaderTextureSampleNode }
Function ShaderSamplerNode.Compile(Target:ShaderCompiler): Boolean;
Begin
  Result := _A.Compile(Target);

  If Result Then
  Begin
    Result := _B.Compile(Target);
  End Else
    Exit;

  If Result Then
  Begin
    _Block := Target.GenerateTextureSampler(_A._Block, _B._Block);
    Result := Assigned(_Block);
  End;
End;

Function ShaderSamplerNode.GetType: ShaderNodeType;
Begin
  If (_A Is ShaderUniformNode) And (IsSampler(ShaderUniformNode(_A)._Type)) Then
  Begin
    Result := ShaderUniformNode(_A)._Type;
  End Else
    Result := ShaderNode_Invalid;
End;

Function ShaderSamplerNode.Validate: Boolean;
Begin
  Result := (IsSampler(_A.GetType())) And (_B.GetType() = ShaderNode_Vector2D);
End;


{ ShaderUniformNode }
Function ShaderUniformNode.Compile(Target: ShaderCompiler): Boolean;
Begin
  _Block := Target.GenerateUniform(_Name, _Type);
  Result := Assigned(_Block);
End;

Function ShaderUniformNode.GetType: ShaderNodeType;
Begin
  Result := _Type;
End;

{ TERRAShaderGroup }
Procedure TERRAShaderGroup.AddNode(Node: TERRAShaderNode);
Var
  I:Integer;
Begin
  If Node = Nil Then
    Exit;

  For I:=0 To Pred(_NodeCount) Do
  If (_Nodes[I] = Node) Then
    Exit;

  Inc(_NodeCount);
  SetLength(_Nodes, _NodeCount);
  _Nodes[Pred(_NodeCount)] := Node;
End;

Constructor TERRAShaderGroup.Create(const Name: TERRAString);
Begin
  Inherited Create();
  Self._ObjectName := Name;
End;

Function TERRAShaderGroup.GenerateCode(Target:TERRAShaderNode; Compiler:ShaderCompiler; Out VertexShader, FragmentShader:TERRAString):Boolean;
Begin
  If Self.XVertexCode<>'' Then
  Begin
     VertexShader := XVertexCode;
     FragmentShader := XFragmentCode;
     Result := True;
    Exit;
  End;

  Result := Target.Compile(Compiler);

  If Result Then
    Result := Compiler.GenerateCode(VertexShader, FragmentShader);
End;

Function TERRAShaderGroup.GetSubNodeAt(Index: Integer): TERRAShaderNode;
Begin
  If (Index<0) Or (Index>=_NodeCount) Then
    Result := Nil
  Else
    Result := _Nodes[Index];
End;

Function TERRAShaderGroup.GetSubNodeCount: Integer;
Begin
  Result := _NodeCount;
End;

{ ShaderOutputNode }
Constructor ShaderOutputNode.Create(Kind: ShaderOutputType);
Begin
  Self.OutputType := Kind;
End;

Function ShaderOutputNode.Compile(Target: ShaderCompiler): Boolean;
Begin
  Result := Self._Input.Compile(Target);
  If Not Result Then
    Exit;

  _Block := Target.GenerateOutput(Self._Input._Block, _Output);
  Result := Assigned(_Block);
End;

Function ShaderOutputNode.GetType: ShaderNodeType;
Begin
  Result := ShaderNode_Output;
End;

{ ShaderAttributeNode }
Function ShaderAttributeNode.Compile(Target: ShaderCompiler): Boolean;
Begin
  _Block := Target.GenerateAttribute(_Name, _Kind, _Type);
  Result := Assigned(_Block);
End;

Constructor ShaderAttributeNode.Create(Const Name: TERRAString; AttrKind: VertexFormatAttribute; AttrType: ShaderNodeType);
Begin
  Self._Name := Name;
  Self._Kind := AttrKind;
  Self._Type := AttrType;
End;

Function ShaderAttributeNode.GetType: ShaderNodeType;
Begin
  Result := _Type;
End;

{ ShaderUnaryFunctionNode }
Function ShaderUnaryFunctionNode.Compile(Target: ShaderCompiler): Boolean;
Begin
  Result := _Input.Compile(Target);

  If Not Result Then
    Exit;

  _Block := Target.GenerateUnaryFunctionCall(_Input._Block, _Func);
  Result := Assigned(_Block);
End;

Function ShaderUnaryFunctionNode.GetType: ShaderNodeType;
Begin
  Case _Func Of
    shaderFunction_Length,
    shaderFunction_Sqrt,
    shaderFunction_Abs,
    shaderFunction_Normalize,
    shaderFunction_Sign,
    shaderFunction_Ceil,
    shaderFunction_Floor,
    shaderFunction_Round,
    shaderFunction_Trunc,
    shaderFunction_Frac,
    shaderFunction_Cos,
    shaderFunction_Sin,
    shaderFunction_Tan:
      Result := _Input.GetType();
    Else
      Result := ShaderNode_Invalid;
  End;
End;

Function ShaderUnaryFunctionNode.Validate: Boolean;
Begin
  Result := (GetType() <> ShaderNode_Invalid) And (Not IsSampler(GetType()));
End;

{ ShaderBinaryFunctionNode }
Function ShaderBinaryFunctionNode.Compile(Target: ShaderCompiler): Boolean;
Begin
  Result := _A.Compile(Target);

  If Result Then
  Begin
    Result := _B.Compile(Target);
  End Else
    Exit;

  If Result Then
  Begin
    _Block := Target.GenerateBinaryFunctionCall(_A._Block, _B._Block, _Func);
    Result := Assigned(_Block);
  End;
End;

Function ShaderBinaryFunctionNode.GetType: ShaderNodeType;
Begin
  Case _Func Of
    shaderFunction_Add,
    shaderFunction_Subtract,
    shaderFunction_Multiply,
    shaderFunction_Divide,
    shaderFunction_Modulus,
    shaderFunction_DotProduct,
    shaderFunction_CrossProduct,
    shaderFunction_Pow,
    shaderFunction_Min,
    shaderFunction_Max,
    shaderFunction_Step,
    shaderFunction_SmoothStep:
      Result := _A.GetType();
    Else
      Result := ShaderNode_Invalid;
  End;
End;

{ ShaderTernaryFunctionNode }
Function ShaderTernaryFunctionNode.Compile(Target: ShaderCompiler): Boolean;
Begin
  Result := _A.Compile(Target);

  If Result Then
  Begin
    Result := _B.Compile(Target);
  End Else
    Exit;

  If Result Then
  Begin
    Result := _C.Compile(Target);
  End Else
    Exit;

  If Result Then
  Begin
    _Block := Target.GenerateTernaryFunctionCall(_A._Block, _B._Block, _C._Block, _Func);
    Result := Assigned(_Block);
  End;
End;

{ ShaderBinaryOptionNode }

Function ShaderBinaryOptionNode.Compile(Target: ShaderCompiler): Boolean;
Var
  Choice:TERRAShaderNode;
Begin
  If (Self._Option <>0) Then
    Choice := _A
  Else
    Choice := _B;

  Result := Choice.Compile(Target);
  If Not Result Then
    Exit;

  _Block := Choice._Block;
  Result := Assigned(_Block);
End;

End.
