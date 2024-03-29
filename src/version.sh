# Tagged release
if [[ ${GITHUB_REF} == refs/tags/* ]]; then
    # Strip git ref prefix from $VERSION
    VERSION=$(echo "${GITHUB_REF}" | sed -e 's,.*/\(.*\),\1,')
else
    VERSION=${GITHUB_SHA}
fi

echo "$VERSION"