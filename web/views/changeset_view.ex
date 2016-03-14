defmodule GpsTracker.ChangesetView do
  use GpsTracker.Web, :view

  # def translate_errors(changeset) do
  #   Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  # end
  # TODO: add gettext support

  def render("error.json", %{changeset: changeset}) do
    # When encoded, the changeset returns its errors
    # as a JSON object. So we just pass it forward.
    # %{errors: translate_errors(changeset)}
    %{errors: changeset}
  end
end
