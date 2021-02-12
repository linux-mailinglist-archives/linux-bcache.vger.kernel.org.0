Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245D531A095
	for <lists+linux-bcache@lfdr.de>; Fri, 12 Feb 2021 15:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbhBLOXc (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 12 Feb 2021 09:23:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:60160 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231768AbhBLOXc (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 12 Feb 2021 09:23:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9BBE0B029;
        Fri, 12 Feb 2021 14:22:50 +0000 (UTC)
Subject: Re: [PATCH][next] bcache: Use 64-bit arithmetic instead of 32-bit
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christina Jacob <cjacob@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210212125028.GA264620@embeddedor>
From:   Coly Li <colyli@suse.de>
Message-ID: <ea24a361-ab1f-a330-b5e6-007bb9a1013b@suse.de>
Date:   Fri, 12 Feb 2021 22:22:44 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210212125028.GA264620@embeddedor>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2/12/21 8:50 PM, Gustavo A. R. Silva wrote:
> Cast multiple variables to (int64_t) in order to give the compiler
> complete information about the proper arithmetic to use. Notice that
> these variables are being used in contexts that expect expressions of
> type int64_t  (64 bit, signed). And currently, such expressions are
> being evaluated using 32-bit arithmetic.
> 
> Fixes: d0cf9503e908 ("octeontx2-pf: ethtool fec mode support")
> Addresses-Coverity-ID: 1501724 ("Unintentional integer overflow")
> Addresses-Coverity-ID: 1501725 ("Unintentional integer overflow")
> Addresses-Coverity-ID: 1501726 ("Unintentional integer overflow")
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/md/bcache/writeback.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index 82d4e0880a99..4fb635c0baa0 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -110,13 +110,13 @@ static void __update_writeback_rate(struct cached_dev *dc)
>  		int64_t fps;
>  
>  		if (c->gc_stats.in_use <= BCH_WRITEBACK_FRAGMENT_THRESHOLD_MID) {
> -			fp_term = dc->writeback_rate_fp_term_low *
> +			fp_term = (int64_t)dc->writeback_rate_fp_term_low *
>  			(c->gc_stats.in_use - BCH_WRITEBACK_FRAGMENT_THRESHOLD_LOW);
>  		} else if (c->gc_stats.in_use <= BCH_WRITEBACK_FRAGMENT_THRESHOLD_HIGH) {
> -			fp_term = dc->writeback_rate_fp_term_mid *
> +			fp_term = (int64_t)dc->writeback_rate_fp_term_mid *
>  			(c->gc_stats.in_use - BCH_WRITEBACK_FRAGMENT_THRESHOLD_MID);
>  		} else {
> -			fp_term = dc->writeback_rate_fp_term_high *
> +			fp_term = (int64_t)dc->writeback_rate_fp_term_high *
>  			(c->gc_stats.in_use - BCH_WRITEBACK_FRAGMENT_THRESHOLD_HIGH);
>  		}
>  		fps = div_s64(dirty, dirty_buckets) * fp_term;
> 

Hmm, should such thing be handled by compiler ?  Otherwise this kind of
potential overflow issue will be endless time to time.

I am not a compiler expert, should we have to do such explicit type cast
all the time ?

Coly Li
