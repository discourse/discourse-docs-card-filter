import Component from "@ember/component";
import { classNames } from "@ember-decorators/component";
import CardsFilter from "../../../discourse/components/cards-filter";

@classNames("before-docs-search-outlet", "card-filter")
export default class CardFilter extends Component {
  <template>
    <CardsFilter
      @updateSelectedCategory={{this.selectCategory}}
      @updateSelectedTag={{this.selectTag}}
      @tags={{this.tags}}
      @categories={{this.categories}}
    />
  </template>
}
