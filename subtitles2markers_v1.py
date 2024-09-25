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

# Obtém todas as faixas de legenda
track_count = timeline.GetTrackCount("subtitle")

# Verifica se há faixas de legendas
if track_count == 0:
    print("Nenhuma faixa de legendas encontrada.")
    exit()

# Itera sobre todas as faixas de legendas
for track_index in range(1, track_count + 1):
    clips = timeline.GetItemListInTrack("subtitle", track_index)
    if len(clips) > 0:
        # Adiciona um marcador no início de cada legenda
        for i, clip in enumerate(clips):
            start_time = clip.GetStart()
            subtitle_text = clip.GetName()  # Obtém o texto da legenda

            # Adiciona o marcador com o texto da legenda no campo "Name"
            timeline.AddMarker(start_time, "Yellow", subtitle_text, f"Marcador na legenda {i+1}", 1)
            print(f"Marcador adicionado na legenda {i+1} no tempo {start_time} com o texto no Name: {subtitle_text}")

print("Todos os marcadores foram adicionados com os textos das legendas no campo 'Name'!")
