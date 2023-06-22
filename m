Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0D9739E8A
	for <lists+linux-bcache@lfdr.de>; Thu, 22 Jun 2023 12:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbjFVK0c (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 22 Jun 2023 06:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbjFVK0a (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 22 Jun 2023 06:26:30 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9100E1981;
        Thu, 22 Jun 2023 03:26:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1D9A422A96;
        Thu, 22 Jun 2023 10:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1687429585; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZZWYKUlDfSTj1PZOZLgcPBdZ56LIBegjI8tEFmTreSk=;
        b=3YyB/k0+KL1hkjwDbbwcxxmt2b1NB09ycaVfO/W7d0YAutPA1DoUszFWULUxXytVGYRy3I
        kBT+vK+8XjQLuCyaqLpEo8EB9PejfI8ieQ8j9z4c1X1ouCmK90Hk3e1Iz1plFfZH8IFU32
        /fqthny4+OoxTXufG7eI9WUJMslQFng=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1687429585;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZZWYKUlDfSTj1PZOZLgcPBdZ56LIBegjI8tEFmTreSk=;
        b=bixnhqmjXWq9HpY/fty6ZymFjCmKB3XcTLSgM+SLApUabRkjD6Ec46ynW8WAkPoqFL43Lh
        Y81gyCfDO66TC6Ag==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0BFA913905;
        Thu, 22 Jun 2023 10:26:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id hw/qAtEhlGTNPAAAMHmgww
        (envelope-from <jack@suse.cz>); Thu, 22 Jun 2023 10:26:25 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 92BA6A075D; Thu, 22 Jun 2023 12:26:24 +0200 (CEST)
Date:   Thu, 22 Jun 2023 12:26:24 +0200
From:   Jan Kara <jack@suse.cz>
To:     kernel test robot <lkp@intel.com>
Cc:     Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        oe-kbuild-all@lists.linux.dev,
        Christoph Hellwig <hch@infradead.org>,
        linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        linux-bcache@vger.kernel.org
Subject: Re: [PATCH 2/2] bcache: Fix bcache device claiming
Message-ID: <20230622102624.ya5xc3asoeuqpxrn@quack3>
References: <20230621162333.30027-2-jack@suse.cz>
 <202306220927.dRUNZbek-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202306220927.dRUNZbek-lkp@intel.com>
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi,

On Thu 22-06-23 09:23:21, kernel test robot wrote:
> Hi Jan,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on axboe-block/for-6.5/block]
> [also build test ERROR on next-20230621]
> [cannot apply to linus/master v6.4-rc7]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]

Yeah, there's missing '{' there. The two fixes were part of a larger series
and I've mistakenly fixed this up only in the next patch in the series.
I'll resend once we agree with Kent how to proceed.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
