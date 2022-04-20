Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6016508039
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Apr 2022 06:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238756AbiDTEmP (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 20 Apr 2022 00:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354192AbiDTEmP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 20 Apr 2022 00:42:15 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBEDE1ADB5;
        Tue, 19 Apr 2022 21:39:30 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 684B667373; Wed, 20 Apr 2022 06:39:27 +0200 (CEST)
Date:   Wed, 20 Apr 2022 06:39:27 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     axboe@kernel.dk, hch@lst.de, kch@nvidia.com, snitzer@redhat.com,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 0/2] bcache fixes for Linux v5.18-rc3
Message-ID: <20220420043927.GA1363@lst.de>
References: <20220419160425.4148-1-colyli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419160425.4148-1-colyli@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
