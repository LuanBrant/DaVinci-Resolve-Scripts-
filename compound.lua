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

-- Função para obter todos os clipes da trilha V1
function getClipsInV1(timeline)
    clips = timeline:GetItemListInTrack("video", 1)  -- Obtém todos os clipes de vídeo na trilha V1
    
    if #clips == 0 then
        print("Nenhum clipe foi encontrado na trilha V1.")
        return nil
    end

    return clips
end

-- Obtém os clipes da trilha de vídeo V1
videoClips = getClipsInV1(timeline)

if videoClips == nil then
    return
end

-- Verifica se há clipes na trilha V1
if #videoClips == 0 then
    print("Nenhum clipe foi encontrado na trilha V1.")
    return
end

-- Calcula o tempo de início e fim dos clipes
startTime = videoClips[1]:GetStart()  -- Obtém o tempo de início do primeiro clipe
endTime = videoClips[#videoClips]:GetEnd()  -- Obtém o tempo de fim do último clipe

-- Cria um novo Compound Clip no Media Pool
mediaPool = project:GetMediaPool()
compoundClipName = "Compound Clip V1"

-- Cria um novo Compound Clip diretamente no Media Pool
compoundClip = mediaPool:AddCompoundClip({startTime, endTime}, compoundClipName)

if compoundClip then
    print("Compound Clip criado com sucesso: " .. compoundClipName)
else
    print("Falha ao criar o Compound Clip.")
end