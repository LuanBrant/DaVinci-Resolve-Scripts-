-- Inicializa o DaVinci Resolve
resolve = Resolve()
projectManager = resolve:GetProjectManager()
project = projectManager:GetCurrentProject()

-- Verifica se há um projeto aberto
if not project then
    print("Nenhum projeto aberto no momento.")
    return
end

-- Obtém a timeline ativa
timeline = project:GetCurrentTimeline()

-- Verifica se há uma timeline ativa
if not timeline then
    print("Nenhuma timeline ativa encontrada.")
    return
end

-- Obtém todas as legendas na timeline
subtitleTrackCount = timeline:GetTrackCount("subtitle")

if subtitleTrackCount == 0 then
    print("Nenhuma faixa de legenda encontrada.")
    return
end

-- Obtém todas as legendas na primeira faixa de legendas
subtitleClips = timeline:GetItemListInTrack("subtitle", 1)
if #subtitleClips == 0 then
    print("Nenhuma legenda encontrada na primeira faixa.")
    return
end

-- Processa cada legenda
for i, subtitleClip in ipairs(subtitleClips) do
    -- Obtém os pontos de entrada, saída e o texto de cada legenda
    subtitleStart = subtitleClip:GetStart()
    subtitleEnd = subtitleClip:GetEnd()  -- Agora também obtemos o ponto de saída
    subtitleText = subtitleClip:GetName()  -- Obtém o conteúdo da legenda

    print("Legenda " .. i .. " encontrada com tempo de entrada: " .. subtitleStart)
    print("Tempo de saída da legenda: " .. subtitleEnd)
    print("Texto da legenda: " .. subtitleText)

    -- Agora encontra o clipe na faixa V1 que está imediatamente abaixo desta legenda
    videoTrackClips = timeline:GetItemListInTrack("video", 1)

    if #videoTrackClips == 0 then
        print("Nenhum clipe encontrado na faixa V1.")
        return
    end

    -- Procura o clipe de vídeo cuja duração abrange a entrada da legenda
    clipBelowSubtitle = nil

    for _, clip in ipairs(videoTrackClips) do
        clipStart = clip:GetStart()
        clipEnd = clip:GetEnd()

        -- Verifica se o clipe cobre a entrada e saída da legenda
        if clipStart <= subtitleStart and clipEnd >= subtitleEnd then
            clipBelowSubtitle = clip
            break
        end
    end

    if not clipBelowSubtitle then
        print("Nenhum clipe encontrado abaixo da legenda " .. i .. " na faixa V1.")
        -- Passa para a próxima legenda em vez de parar a execução
        goto continue
    end

    -- Obtém o item do Media Pool correspondente ao clipe
    mediaPoolItem = clipBelowSubtitle:GetMediaPoolItem()

    if not mediaPoolItem then
        print("Nenhum item do Media Pool correspondente encontrado para a legenda " .. i .. ".")
        -- Passa para a próxima legenda
        goto continue
    end

    -- Obtém o ponto de entrada (In Point) e a taxa de quadros do clipe no Media Pool
    clipInPoint = tonumber(mediaPoolItem:GetClipProperty("Start"))  -- Ponto de início no arquivo de mídia
    frameRate = tonumber(mediaPoolItem:GetClipProperty("FPS"))      -- Taxa de quadros do clipe

    if not clipInPoint or not frameRate then
        print("Erro ao obter o In Point ou a taxa de quadros do clipe no Media Pool.")
        -- Passa para a próxima legenda
        goto continue
    end

    -- Obtém o ponto de início do clipe na timeline
    clipStartInTimeline = clipBelowSubtitle:GetStart()

    -- Calcula a diferença em frames entre o início do clipe na timeline e os pontos de entrada e saída da legenda
    timelineOffsetFramesStart = math.floor((subtitleStart - clipStartInTimeline) * frameRate)
    timelineOffsetFramesEnd = math.floor((subtitleEnd - clipStartInTimeline) * frameRate)

    -- Calcula os frames correspondentes no clipe no Media Pool para o ponto de entrada e saída
    relativeSubtitleStart = clipInPoint + (timelineOffsetFramesStart / frameRate)
    relativeSubtitleEnd = clipInPoint + (timelineOffsetFramesEnd / frameRate)

    print("Legenda " .. i .. " ajustada para o clipe com tempo de entrada: " .. relativeSubtitleStart)
    print("Legenda " .. i .. " ajustada para o clipe com tempo de saída: " .. relativeSubtitleEnd)

    -- Cria um marcador de duração no Media Pool, baseado nos tempos ajustados de entrada e saída
    markerColor = "Red"
    markerName = subtitleText  -- Coloca o texto da legenda no campo "Name"
    markerNotes = "Legenda " .. i  -- Informativo no campo "Notes" indicando o número da legenda

    -- O comprimento do marcador é definido pela diferença entre os pontos de entrada e saída
    mediaPoolItem:AddMarker(relativeSubtitleStart, markerColor, markerName, markerNotes, (relativeSubtitleEnd - relativeSubtitleStart))

    print("Marcador de duração criado no clipe do Media Pool para a legenda " .. i)

    -- Continua para a próxima legenda
    ::continue::
end

print("Todos os marcadores de legenda foram criados!")