{{/*
Expand the name of the chart.
*/}}
{{- define "ollama.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ollama.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ollama.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ollama.labels" -}}
helm.sh/chart: {{ include "ollama.chart" . }}
{{ include "ollama.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ollama.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ollama.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ollama.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ollama.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "app.volumes" -}}
{{ $sanitized_image_tag := lower .image.tag | replace "." "" |  replace " " "" }}
{{- if (.volumeMounts) }}
{{- if .volumeMounts.enabled }}
volumes:
{{- range $i,$mount := .volumeMounts.mounts }}
{{ $appendImageTagOption := default false $mount.appendImageTag   }}
{{- if or $mount.subPath $mount.keys }}
  - name: {{ $mount.name }}-{{ $i }}
{{- else }}
  - name: {{ $mount.name }}
{{- end }}
  {{- if eq $mount.type "secret" }}
    secret: 
  {{- if (default $appendImageTagOption  false) }}
      secretName: {{ $mount.name }}-{{ $sanitized_image_tag }}
  {{- else }}
      secretName: {{ $mount.name }}
  {{- end }}
      {{- if $mount.defaultMode }}
      defaultMode: {{ $mount.defaultMode }}
      {{- end }}
      {{- if $mount.keys }}
      items:
      {{- range $secret := $mount.keys }}
      - key: {{ $secret.key }}
        path: {{ $secret.path }}
      {{- end }}
      {{- end }}
  {{- else if eq "configmap" $mount.type }}
    configMap: 
   {{- if (default $appendImageTagOption  false) }}
      name: {{ $mount.name }}-{{ $sanitized_image_tag }}
   {{- else }} 
      name: {{ $mount.name }}  
   {{- end }}  
      {{- if $mount.defaultMode }}
      defaultMode: {{ $mount.defaultMode }}
      {{- end }}
      {{- if $mount.keys }}
      items:
      {{- range $cm := $mount.keys }}
      - key: {{ $cm.key }}
        path: {{ $cm.path }}
      {{- end }}
      {{- end }}
  {{- else if eq "pvc" $mount.type }}
    persistentVolumeClaim: 
      claimName: {{ $mount.name }}
  {{- else }}
    emptyDir: {} 
  {{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end -}}

{{- define "volumeMounts" -}}
volumeMounts:
{{/*
- name: shared-tmp
  mountPath: /tmp/pod
*/}}
{{- if (.volumeMounts) }}
{{- if .volumeMounts.enabled }}
{{- range $i,$mount := .volumeMounts.mounts }}
{{- if or $mount.subPath $mount.keys }}
- name: {{ $mount.name }}-{{ $i }}
  subPath: {{ $mount.subPath }}
{{- else }}
- name: {{ $mount.name }}
{{- end }}
  mountPath: {{ $mount.mountPath }}
  {{- if $mount.readOnly }}
  readOnly: {{ $mount.readOnly }}
  {{- end }}

{{- end }}
{{- end }}
{{- end }}
{{- end -}}
