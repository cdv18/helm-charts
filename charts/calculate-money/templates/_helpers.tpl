{{/*
Expand the name of the chart.
*/}}
{{- define "calculate-money.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "calculate-money.fullname" -}}
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
{{- define "calculate-money.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "calculate-money.labels" -}}
helm.sh/chart: {{ include "calculate-money.chart" . }}
{{ include "calculate-money.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "calculate-money.selectorLabels" -}}
app.kubernetes.io/name: {{ include "calculate-money.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "calculate-money.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "calculate-money.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Frontend fullname
*/}}
{{- define "calculate-money.frontend.fullname" -}}
{{- printf "%s-%s" (include "calculate-money.fullname" .) "frontend" }}
{{- end }}

{{/*
Frontend selector labels
*/}}
{{- define "calculate-money.frontend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "calculate-money.name" . }}-frontend
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
