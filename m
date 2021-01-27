Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1D7306236
	for <lists+linux-bcache@lfdr.de>; Wed, 27 Jan 2021 18:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344066AbhA0RiY (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 27 Jan 2021 12:38:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344063AbhA0RiR (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 Jan 2021 12:38:17 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EC9C061786;
        Wed, 27 Jan 2021 09:37:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YaFdXSUHW5FIAlVx4y0CuWUWT2r4U8L8ne2N7fAgDNs=; b=l9CFUx7k+D1EIyoS/6EM2sSE5g
        77Lx88DPf4cWjAEPmxigkYvxRnGyODQYNnY0Kaqi071Jy7PLMq27LTyPqKaTZ2tSyje2ZHh/PnnYo
        xob+nARKVMRAtXvn1UcsjhjYdEWzORBWEiTf5QJUgtiqDfXZEw0WHzduhDH/ARPkI8qO7qM77ZWIN
        lTo0Xi/zxXTSlgFHnYu2ZoXqu4eWHXmLP3nbm+Z31ykp2kHc6P4rjYIYVWpKUKEDDOS3X8tj8UgKj
        Xj6pIcy7rqV9fAYdKZu2f243Y0bJkQBHcC6pT6tuh+NHk5fCDDbbPNDzvDHnyw+jfrDpbnMMU1eP6
        p57tE5GA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l4okw-007IV5-3V; Wed, 27 Jan 2021 17:37:27 +0000
Date:   Wed, 27 Jan 2021 17:37:26 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, mchristi@redhat.com
Subject: Re: [PATCH] bcache: dont reset bio opf in bch_data_insert_start
Message-ID: <20210127173726.GA1738577@infradead.org>
References: <20210125042942.1087170-1-dongsheng.yang@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125042942.1087170-1-dongsheng.yang@easystack.cn>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

But the old code is also completely broken.  We can't just OR in
the op, as that implicitly assumes the old op was 0 (REQ_OP_READ).

Please fix this to explicitly set the exact op and flags that you want
instead of this fragile magic.
