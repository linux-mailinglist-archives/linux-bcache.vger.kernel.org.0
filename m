Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4E75248F05
	for <lists+linux-bcache@lfdr.de>; Tue, 18 Aug 2020 21:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgHRTsj (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 18 Aug 2020 15:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbgHRTsj (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 18 Aug 2020 15:48:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8026C061389;
        Tue, 18 Aug 2020 12:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3K0FQWCpxkDdpzYdicrbQTL+aSH1Bv0zE5559DIxof4=; b=b55Q+9dZkd7BFTZCFnWleH9P1s
        VKWsvrAdrNY0xnzjxQ7uVmzDz6CgaP3FyqJgQTUJRMsIBqw7TRwYah1Fy48HLxqZTgZsfKMLmRNGE
        +qCG4F/bC4k6o3fkuNPHHHjZW9AdWLj78rMyI8MKqMK+XcKnYcOqOZyB5N4NTLZvsKhnsQ1CSV47O
        tqwlbR5zoeJPBd5Bf+21/vGKUfKAvYZfoejs/GG3DZuh9WFK6ybNrnm+ZXx0Xw9MpPoscJVxBQYID
        vXB4ZA3zH9WhZAhtzcRAmbC7hBlbfqXPP2dNQ1GeGHTtyvtg8A0iktTaGT75oj192//BNgM61mvbv
        z/+5c+kw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k87b2-0001Ys-AD; Tue, 18 Aug 2020 19:48:36 +0000
Date:   Tue, 18 Aug 2020 20:48:36 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-bcache@vger.kernel.org, colyli@suse.de, axboe@kernel.dk,
        kernel-team@fb.com, song@kernel.org
Subject: Re: [PATCH 2/4] block: introduce part_[begin|end]_io_acct
Message-ID: <20200818194836.GC3271@infradead.org>
References: <20200818070238.1323126-1-songliubraving@fb.com>
 <20200818070238.1323126-3-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818070238.1323126-3-songliubraving@fb.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Aug 18, 2020 at 12:02:36AM -0700, Song Liu wrote:
> These functions can be used to enable iostat for partitions on devices
> like md, bcache.

Please follow a model like bio_start_io_acct - that is pass a bio
for all the input parameters except for the gendisk.  Given that we
don't have anywhere for the part to store that will need another
output paramater.

The end_io function should drop the hd_struct reference as well for
a well rounded API.
