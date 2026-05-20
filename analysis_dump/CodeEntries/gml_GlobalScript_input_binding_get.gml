/*
DECOMPILER FAILED!

Underanalyzer.Decompiler.DecompilerException: Decompiler error during AST building: Dup read too much data from stack (12 -> -4)
 ---> Underanalyzer.Decompiler.DecompilerException: Dup read too much data from stack (12 -> -4)
   at Underanalyzer.Decompiler.AST.BlockSimulator.SimulateDuplicate(ASTBuilder builder, IGMInstruction instr) in C:\Users\ksuti\Desktop\Lake-of-Creatures-Mod-Loader\undertalemodtool-src\Underanalyzer\Underanalyzer\Decompiler\AST\BlockSimulator.cs:line 183
   at Underanalyzer.Decompiler.AST.BlockSimulator.Simulate(ASTBuilder builder, List`1 output, Block block) in C:\Users\ksuti\Desktop\Lake-of-Creatures-Mod-Loader\undertalemodtool-src\Underanalyzer\Underanalyzer\Decompiler\AST\BlockSimulator.cs:line 91
   at Underanalyzer.Decompiler.ControlFlow.Block.BuildAST(ASTBuilder builder, List`1 output) in C:\Users\ksuti\Desktop\Lake-of-Creatures-Mod-Loader\undertalemodtool-src\Underanalyzer\Underanalyzer\Decompiler\ControlFlow\Block.cs:line 299
   at Underanalyzer.Decompiler.AST.ASTBuilder.BuildBlock(IControlFlowNode startNode) in C:\Users\ksuti\Desktop\Lake-of-Creatures-Mod-Loader\undertalemodtool-src\Underanalyzer\Underanalyzer\Decompiler\AST\ASTBuilder.cs:line 110
   at Underanalyzer.Decompiler.ControlFlow.WithLoop.BuildAST(ASTBuilder builder, List`1 output) in C:\Users\ksuti\Desktop\Lake-of-Creatures-Mod-Loader\undertalemodtool-src\Underanalyzer\Underanalyzer\Decompiler\ControlFlow\WithLoop.cs:line 172
   at Underanalyzer.Decompiler.AST.ASTBuilder.BuildBlock(IControlFlowNode startNode) in C:\Users\ksuti\Desktop\Lake-of-Creatures-Mod-Loader\undertalemodtool-src\Underanalyzer\Underanalyzer\Decompiler\AST\ASTBuilder.cs:line 110
   at Underanalyzer.Decompiler.ControlFlow.BinaryBranch.BuildAST(ASTBuilder builder, List`1 output) in C:\Users\ksuti\Desktop\Lake-of-Creatures-Mod-Loader\undertalemodtool-src\Underanalyzer\Underanalyzer\Decompiler\ControlFlow\BinaryBranch.cs:line 288
   at Underanalyzer.Decompiler.AST.ASTBuilder.BuildBlock(IControlFlowNode startNode) in C:\Users\ksuti\Desktop\Lake-of-Creatures-Mod-Loader\undertalemodtool-src\Underanalyzer\Underanalyzer\Decompiler\AST\ASTBuilder.cs:line 110
   at Underanalyzer.Decompiler.ControlFlow.BinaryBranch.BuildAST(ASTBuilder builder, List`1 output) in C:\Users\ksuti\Desktop\Lake-of-Creatures-Mod-Loader\undertalemodtool-src\Underanalyzer\Underanalyzer\Decompiler\ControlFlow\BinaryBranch.cs:line 288
   at Underanalyzer.Decompiler.AST.ASTBuilder.BuildBlock(IControlFlowNode startNode) in C:\Users\ksuti\Desktop\Lake-of-Creatures-Mod-Loader\undertalemodtool-src\Underanalyzer\Underanalyzer\Decompiler\AST\ASTBuilder.cs:line 110
   at Underanalyzer.Decompiler.AST.IFragmentNode.Create(ASTBuilder builder, Fragment fragment) in C:\Users\ksuti\Desktop\Lake-of-Creatures-Mod-Loader\undertalemodtool-src\Underanalyzer\Underanalyzer\Decompiler\AST\IFragmentNode.cs:line 114
   at Underanalyzer.Decompiler.ControlFlow.Fragment.BuildAST(ASTBuilder builder, List`1 output) in C:\Users\ksuti\Desktop\Lake-of-Creatures-Mod-Loader\undertalemodtool-src\Underanalyzer\Underanalyzer\Decompiler\ControlFlow\Fragment.cs:line 175
   at Underanalyzer.Decompiler.AST.ASTBuilder.BuildBlock(IControlFlowNode startNode) in C:\Users\ksuti\Desktop\Lake-of-Creatures-Mod-Loader\undertalemodtool-src\Underanalyzer\Underanalyzer\Decompiler\AST\ASTBuilder.cs:line 110
   at Underanalyzer.Decompiler.AST.IFragmentNode.Create(ASTBuilder builder, Fragment fragment) in C:\Users\ksuti\Desktop\Lake-of-Creatures-Mod-Loader\undertalemodtool-src\Underanalyzer\Underanalyzer\Decompiler\AST\IFragmentNode.cs:line 33
   at Underanalyzer.Decompiler.ControlFlow.Fragment.BuildAST(ASTBuilder builder, List`1 output) in C:\Users\ksuti\Desktop\Lake-of-Creatures-Mod-Loader\undertalemodtool-src\Underanalyzer\Underanalyzer\Decompiler\ControlFlow\Fragment.cs:line 175
   at Underanalyzer.Decompiler.AST.ASTBuilder.Build() in C:\Users\ksuti\Desktop\Lake-of-Creatures-Mod-Loader\undertalemodtool-src\Underanalyzer\Underanalyzer\Decompiler\AST\ASTBuilder.cs:line 66
   at Underanalyzer.Decompiler.DecompileContext.DecompileAST() in C:\Users\ksuti\Desktop\Lake-of-Creatures-Mod-Loader\undertalemodtool-src\Underanalyzer\Underanalyzer\Decompiler\DecompileContext.cs:line 113
   --- End of inner exception stack trace ---
   at Underanalyzer.Decompiler.DecompileContext.DecompileAST() in C:\Users\ksuti\Desktop\Lake-of-Creatures-Mod-Loader\undertalemodtool-src\Underanalyzer\Underanalyzer\Decompiler\DecompileContext.cs:line 117
   at Underanalyzer.Decompiler.DecompileContext.DecompileToAST() in C:\Users\ksuti\Desktop\Lake-of-Creatures-Mod-Loader\undertalemodtool-src\Underanalyzer\Underanalyzer\Decompiler\DecompileContext.cs:line 155
   at Underanalyzer.Decompiler.DecompileContext.DecompileToString() in C:\Users\ksuti\Desktop\Lake-of-Creatures-Mod-Loader\undertalemodtool-src\Underanalyzer\Underanalyzer\Decompiler\DecompileContext.cs:line 164
   at UndertaleModCli.Program.GetDecompiledText(UndertaleCode code, GlobalDecompileContext context, IDecompileSettings settings) in C:\Users\ksuti\Desktop\Lake-of-Creatures-Mod-Loader\undertalemodtool-src\UndertaleModCli\Program.UMTLibInherited.cs:line 487
*/