      - name: Static security check with Bridgecrew
        id: Bridgecrew
        uses: bridgecrewio/bridgecrew-action@master
        with:
          api-key: ${{ secrets.BC_API_TOKEN }}