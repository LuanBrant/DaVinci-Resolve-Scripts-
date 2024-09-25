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

# Obtém todas as legendas na timeline
subtitle_track_count = timeline.GetTrackCount("subtitle")

if subtitle_track_count == 0:
    print("Nenhuma faixa de legenda encontrada.")
    exit()

# Obtém todas as legendas na primeira faixa de legendas
subtitle_clips = timeline.GetItemListInTrack("subtitle", 1)
if len(subtitle_clips) == 0:
    print("Nenhuma legenda encontrada na primeira faixa.")
    exit()

# Processa cada legenda
for i, subtitle_clip in enumerate(subtitle_clips):
    # Obtém os pontos de entrada, saída e o texto de cada legenda
    subtitle_start = subtitle_clip.GetStart()
    subtitle_end = subtitle_clip.GetEnd()  # Agora também obtemos o ponto de saída
    subtitle_text = subtitle_clip.GetName()  # Obtém o conteúdo da legenda

    print(f"Legenda {i+1} encontrada com tempo de entrada: {subtitle_start}")
    print(f"Tempo de saída da legenda: {subtitle_end}")
    print(f"Texto da legenda: {subtitle_text}")

    # Agora encontra o clipe na faixa V1 que está imediatamente abaixo desta legenda
    video_track_clips = timeline.GetItemListInTrack("video", 1)

    if len(video_track_clips) == 0:
        print("Nenhum clipe encontrado na faixa V1.")
        exit()

    # Procura o clipe de vídeo cuja duração abrange a entrada da legenda
    clip_below_subtitle = None

    for clip in video_track_clips:
        clip_start = clip.GetStart()
        clip_end = clip.GetEnd()

        # Verifica se o clipe cobre a entrada e saída da legenda
        if clip_start <= subtitle_start and clip_end >= subtitle_end:
            clip_below_subtitle = clip
            break

    if not clip_below_subtitle:
        print(f"Nenhum clipe encontrado abaixo da legenda {i+1} na faixa V1.")
        continue

    # Obtém o item do Media Pool correspondente ao clipe
    media_pool_item = clip_below_subtitle.GetMediaPoolItem()

    if not media_pool_item:
        print(f"Nenhum item do Media Pool correspondente encontrado para a legenda {i+1}.")
        continue

    # Obtém o ponto de entrada (In Point) e a taxa de quadros do clipe no Media Pool
    clip_in_point = float(media_pool_item.GetClipProperty("Start"))  # Ponto de início no arquivo de mídia
    frame_rate = float(media_pool_item.GetClipProperty("FPS"))  # Taxa de quadros do clipe

    if not clip_in_point or not frame_rate:
        print("Erro ao obter o In Point ou a taxa de quadros do clipe no Media Pool.")
        continue

    # Obtém o ponto de início do clipe na timeline
    clip_start_in_timeline = clip_below_subtitle.GetStart()

    # Calcula a diferença em frames entre o início do clipe na timeline e os pontos de entrada e saída da legenda
    timeline_offset_frames_start = int((subtitle_start - clip_start_in_timeline) * frame_rate)
    timeline_offset_frames_end = int((subtitle_end - clip_start_in_timeline) * frame_rate)

    # Calcula os frames correspondentes no clipe no Media Pool para o ponto de entrada e saída
    relative_subtitle_start = clip_in_point + (timeline_offset_frames_start / frame_rate)
    relative_subtitle_end = clip_in_point + (timeline_offset_frames_end / frame_rate)

    print(f"Legenda {i+1} ajustada para o clipe com tempo de entrada: {relative_subtitle_start}")
    print(f"Legenda {i+1} ajustada para o clipe com tempo de saída: {relative_subtitle_end}")

    # Cria um marcador de duração no Media Pool, baseado nos tempos ajustados de entrada e saída
    marker_color = "Red"
    marker_name = subtitle_text  # Coloca o texto da legenda no campo "Name"
    marker_notes = f"Legenda {i+1}"  # Informativo no campo "Notes" indicando o número da legenda

    # O comprimento do marcador é definido pela diferença entre os pontos de entrada e saída
    media_pool_item.AddMarker(relative_subtitle_start, marker_color, marker_name, marker_notes, relative_subtitle_end - relative_subtitle_start)

    print(f"Marcador de duração criado no clipe do Media Pool para a legenda {i+1}")

print("Todos os marcadores de legenda foram criados!")
