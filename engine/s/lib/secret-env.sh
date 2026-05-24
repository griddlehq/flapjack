#!/bin/bash

# Read a single KEY=value entry from an env-style file without executing it as shell.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
# TODO: Document read_secret_env_value.
read_secret_env_value() {
  local env_file="$1"
  local key="$2"
  local line=""
  local current_line=""
  local current_key=""
  local value=""

  [ -f "$env_file" ] || return 1
  [ -n "$key" ] || return 1
  [[ "$key" != *=* ]] || return 1

  # Compare parsed keys literally so caller-controlled metacharacters do not
  # alter which secret entry is selected.
  while IFS= read -r current_line || [ -n "$current_line" ]; do
    case "$current_line" in
      *=*)
        current_key="${current_line%%=*}"
        if [ "$current_key" = "$key" ]; then
          line="$current_line"
        fi
        ;;
    esac
  done < "$env_file"
  [ -n "$line" ] || return 1

  value="${line#*=}"
  if [[ "$value" == \"*\" && "$value" == *\" ]]; then
    value="${value:1:${#value}-2}"
  elif [[ "$value" == \'*\' && "$value" == *\' ]]; then
    value="${value:1:${#value}-2}"
  fi

  printf '%s\n' "$value"
}

export_if_unset() {
  local var_name="$1"
  local value="$2"

  [ -n "$value" ] || return 0
  [ -z "${!var_name:-}" ] || return 0

  export "$var_name=$value"
}

openai_fallback_allowed_for_base_url() {
  local base_url="$1"

  case "$base_url" in
    ""|https://api.openai.com/v1|https://api.openai.com/v1/)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

# TODO: Document load_flapjack_runtime_env_from_secret.
load_flapjack_runtime_env_from_secret() {
  local repo_root="$1"
  local env_file="$repo_root/engine/.secret/.env.secret"
  local file_admin_key=""
  local file_ai_base_url=""
  local file_ai_api_key=""
  local file_ai_model=""
  local file_openai_api_key=""

  [ -f "$env_file" ] || return 0

  file_admin_key="$(read_secret_env_value "$env_file" "FLAPJACK_ADMIN_KEY" || true)"
  file_ai_base_url="$(read_secret_env_value "$env_file" "FLAPJACK_AI_BASE_URL" || true)"
  file_ai_api_key="$(read_secret_env_value "$env_file" "FLAPJACK_AI_API_KEY" || true)"
  file_ai_model="$(read_secret_env_value "$env_file" "FLAPJACK_AI_MODEL" || true)"
  file_openai_api_key="$(read_secret_env_value "$env_file" "OPENAI_API_KEY_forFlapjack" || true)"

  export_if_unset "FLAPJACK_ADMIN_KEY" "$file_admin_key"
  export_if_unset "FLAPJACK_AI_BASE_URL" "$file_ai_base_url"
  export_if_unset "FLAPJACK_AI_API_KEY" "$file_ai_api_key"
  export_if_unset "FLAPJACK_AI_MODEL" "$file_ai_model"

  # Only reuse the OpenAI fallback key when the effective base URL is also
  # OpenAI. Otherwise a custom provider URL could receive the wrong secret.
  if openai_fallback_allowed_for_base_url "${FLAPJACK_AI_BASE_URL:-}"; then
    export_if_unset "FLAPJACK_AI_API_KEY" "$file_openai_api_key"
  fi

  if [ -z "${FLAPJACK_AI_BASE_URL:-}" ] && [ -n "${FLAPJACK_AI_API_KEY:-}" ]; then
    export FLAPJACK_AI_BASE_URL="https://api.openai.com/v1"
  fi

  if [ -z "${FLAPJACK_AI_MODEL:-}" ] && [ -n "${FLAPJACK_AI_API_KEY:-}" ]; then
    export FLAPJACK_AI_MODEL="gpt-4o-mini"
  fi
}
