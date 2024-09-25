# Inicializa o DaVinci Resolve
import DaVinciResolveScript as dvr

resolve = dvr.scriptapp("Resolve")
projectManager = resolve.GetProjectManager()
project = projectManager.GetCurrentProject()

# Verifica se há um projeto aberto
if not project:
    print("Nenhum projeto aberto no momento.")
    exit()

# Obtém a timeline ativa
timeline = project.GetCurrentTimeline()

# Verifica se há uma timeline ativa
if not timeline:
    print("Nenhuma timeline ativa encontrada.")
    exit()

# Função para obter todos os clipes da trilha V1
def get_clips_in_v1(timeline):
    clips = timeline.GetItemListInTrack("video", 1)  # Obtém todos os clipes de vídeo na trilha V1
    
    if len(clips) == 0:
        print("Nenhum clipe foi encontrado na trilha V1.")
        return None

    return clips

# Obtém os clipes da trilha de vídeo V1
video_clips = get_clips_in_v1(timeline)

if video_clips is None:
    exit()

# Verifica se há clipes na trilha V1
if len(video_clips) == 0:
    print("Nenhum clipe foi encontrado na trilha V1.")
    exit()

# Calcula o tempo de início e fim dos clipes
start_time = video_clips[0].GetStart()  # Obtém o tempo de início do primeiro clipe
end_time = video_clips[-1].GetEnd()  # Obtém o tempo de fim do último clipe

# Cria um novo Compound Clip no Media Pool
media_pool = project.GetMediaPool()
compound_clip_name = "Compound Clip V1"

# Cria um novo Compound Clip diretamente no Media Pool
compound_clip = media_pool.AddCompoundClip([start_time, end_time], compound_clip_name)

if compound_clip:
    print(f"Compound Clip criado com sucesso: {compound_clip_name}")
else:
    print("Falha ao criar o Compound Clip.")
