
import importlib.util

spec = importlib.util.spec_from_file_location('DaVinciResolveScript', 'C:/ProgramData/Blackmagic Design/DaVinci Resolve/Support/Developer/Scripting/Modules/DaVinciResolveScript.py')
dvr_script = importlib.util.module_from_spec(spec)
spec.loader.exec_module(dvr_script)


resolve = dvr_script.scriptapp('resolve')

print("resolve",resolve)