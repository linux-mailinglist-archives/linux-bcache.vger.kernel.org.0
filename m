Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1946F2E1A3B
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Dec 2020 10:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgLWI7L (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Dec 2020 03:59:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbgLWI7K (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Dec 2020 03:59:10 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDE8C0613D3;
        Wed, 23 Dec 2020 00:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=Drt9kxZ7Ac6Ujibm0wEYpL40lB
        EcPYeOcKOk/1TziuRPUOh1XjMOtq0ZK99mb6UE9rQea2uOBiNnWZxkltSzrZbFnybIuuqgmaMgEZY
        nydyAaR/RIS9ORtbDpS0uzJKIUhTxAWYQae20oTfkBQw4wy0vlF07racTpx4VDUt4SjM8PL9aFCuy
        /iLeE8hV3n08vqClJ7M4Bm2lZrGLAAIivw1URX5+auQSNPzEKvgXCv6i7uO/vIB7S610XqSTP/Qn9
        1d+9Z+0dPrt0iEpUI/FfsLrgY2TwpDHxdATMD8bcJwpBJRfwl2HE4qPPYkQsc1whhRJKibXxswmrK
        6Qdm0KPA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1krzyP-0000Rj-Pr; Wed, 23 Dec 2020 08:58:21 +0000
Date:   Wed, 23 Dec 2020 08:58:21 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Yi Li <yili@winhong.com>
Cc:     colyli@suse.de, yilikernel@gmail.com, kent.overstreet@gmail.com,
        hch@lst.de, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] bcache:remove a superfluous check in register_bcache
Message-ID: <20201223085821.GA1313@infradead.org>
References: <4891349b-2136-eb8b-758d-f937b558b1c0@suse.de>
 <20201221094943.1712589-1-yili@winhong.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201221094943.1712589-1-yili@winhong.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
