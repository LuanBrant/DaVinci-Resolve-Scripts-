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

-- Obtém todas as faixas de legenda
trackCount = timeline:GetTrackCount("subtitle")

-- Verifica se há faixas de legendas
if trackCount == 0 then
    print("Nenhuma faixa de legendas encontrada.")
    return
end

-- Itera sobre todas as faixas de legendas
for trackIndex = 1, trackCount do
    clips = timeline:GetItemListInTrack("subtitle", trackIndex)
    if #clips > 0 then
        -- Adiciona um marcador no início de cada legenda
        for i, clip in ipairs(clips) do
            startTime = clip:GetStart()
            subtitleText = clip:GetName()  -- Obtém o texto da legenda

            -- Adiciona o marcador com o texto da legenda no campo "Name"
            timeline:AddMarker(startTime, "Yellow", subtitleText, "Marcador na legenda " .. i, 1)
            print("Marcador adicionado na legenda " .. i .. " no tempo " .. startTime .. " com o texto no Name: " .. subtitleText)
        end
    end
end

print("Todos os marcadores foram adicionados com os textos das legendas no campo 'Name'!")