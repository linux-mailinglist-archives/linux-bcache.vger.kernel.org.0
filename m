Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A171E644648
	for <lists+linux-bcache@lfdr.de>; Tue,  6 Dec 2022 15:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235167AbiLFOu5 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 6 Dec 2022 09:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235120AbiLFOuy (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 6 Dec 2022 09:50:54 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7462EF26;
        Tue,  6 Dec 2022 06:49:11 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7B3F668B05; Tue,  6 Dec 2022 15:49:02 +0100 (CET)
Date:   Tue, 6 Dec 2022 15:49:02 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        snitzer@kernel.org, Song Liu <song@kernel.org>,
        linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-bcache@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [PATCH] block: remove bio_set_op_attrs
Message-ID: <20221206144902.GA31845@lst.de>
References: <20221206144057.720846-1-hch@lst.de> <434E4CE3-EA46-4CD9-9EAF-5C1B99B8A603@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <434E4CE3-EA46-4CD9-9EAF-5C1B99B8A603@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Dec 06, 2022 at 10:46:31PM +0800, Coly Li wrote:
> BTW, may I ask why bio_set_op_attrs() is removed. Quite long time ago it was added to avoid open code, and now we remove it to use open coded assignments. What is the motivation for now?

It was added when the flags encoding was a mess.  Now that the RQF_
flags are split out things have become much simpler and we don't need
to hide a simple assignment of a value to a field.
